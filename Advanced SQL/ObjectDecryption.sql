
Select newid()


DECLARE 
    @family_guid binary(16) = CONVERT(binary(16), {guid '44ADF67E-1CA8-4D88-8D62-5821D37C8D1B'}), --{guid 'B1FC892E-5824-4FD3-AC48-FBCD91D57763'}
    @objid binary(4) = CONVERT(binary(4), REVERSE(CONVERT(binary(4), 800266156))),
    @subobjid binary(2) = CONVERT(binary(2), REVERSE(CONVERT(binary(2), 0)));


DECLARE 
    @RC4key binary(20) = HASHBYTES('SHA1', @family_guid + @objid + @subobjid);

Select @RC4key

-- The core RC4 algorithm is well-known, and relatively simple. It would be better implemented in a .Net language for efficiency 
-- and performance reasons, but there is a T-SQL implementation below.

--These two T-SQL functions implement the RC4 key-scheduling algorithm and pseudorandom number generator, 
--and were originally written by SQL Server MVP Peter Larsson. I have a made some minor modifications to improve performance a little,
--and allow LOB-length binaries to be encoded and decoded. This part of the process could be replaced by any standard RC4 implementation.




/*
** RC4 functions
** Based on http://www.sqlteam.com/forums/topic.asp?TOPIC_ID=76258
** by Peter Larsson (SwePeso)
*/
IF OBJECT_ID(N'dbo.fnEncDecRc4', N'FN') IS NOT NULL
    DROP FUNCTION dbo.fnEncDecRc4;
GO
IF OBJECT_ID(N'dbo.fnInitRc4', N'TF') IS NOT NULL
    DROP FUNCTION dbo.fnInitRc4;
GO
CREATE FUNCTION dbo.fnInitRc4
    (@Pwd varbinary(256))
RETURNS @Box table
    (
        i tinyint PRIMARY KEY, 
        v tinyint NOT NULL
    )
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @Key table
    (
        i tinyint PRIMARY KEY,
        v tinyint NOT NULL
    );
 
    DECLARE
        @Index smallint = 0,
        @PwdLen tinyint = DATALENGTH(@Pwd);
 
    WHILE @Index <= 255
    BEGIN
        INSERT @Key
            (i, v)
        VALUES
            (@Index, CONVERT(tinyint, SUBSTRING(@Pwd, @Index % @PwdLen + 1, 1)));
 
        INSERT @Box (i, v)
        VALUES (@Index, @Index);
 
        SET @Index += 1;
    END;
 
    DECLARE
        @t tinyint = NULL,
        @b smallint = 0;
 
    SET @Index = 0;
 
    WHILE @Index <= 255
    BEGIN
        SELECT @b = (@b + b.v + k.v) % 256
        FROM @Box AS b
        JOIN @Key AS k
            ON k.i = b.i
        WHERE b.i = @Index;
 
        SELECT @t = b.v
        FROM @Box AS b
        WHERE b.i = @Index;
 
        UPDATE b1
        SET b1.v = (SELECT b2.v FROM @Box AS b2 WHERE b2.i = @b)
        FROM @Box AS b1
        WHERE b1.i = @Index;
 
        UPDATE @Box
        SET v = @t
        WHERE i = @b;
 
        SET @Index += 1;
    END;
 
    RETURN;
END;
GO
CREATE FUNCTION dbo.fnEncDecRc4
(
    @Pwd varbinary(256),
    @Text varbinary(MAX)
)
RETURNS varbinary(MAX)
WITH 
    SCHEMABINDING, 
    RETURNS NULL ON NULL INPUT
AS
BEGIN
    DECLARE @Box AS table 
    (
        i tinyint PRIMARY KEY, 
        v tinyint NOT NULL
    );
 
    INSERT @Box
        (i, v)
    SELECT
        FIR.i, FIR.v
    FROM dbo.fnInitRc4(@Pwd) AS FIR;
 
    DECLARE
        @Index integer = 1,
        @i smallint = 0,
        @j smallint = 0,
        @t tinyint = NULL,
        @k smallint = NULL,
        @CipherBy tinyint = NULL,
        @Cipher varbinary(MAX) = 0x;
 
    WHILE @Index <= DATALENGTH(@Text)
    BEGIN
        SET @i = (@i + 1) % 256;
 
        SELECT
            @j = (@j + b.v) % 256,
            @t = b.v
        FROM @Box AS b
        WHERE b.i = @i;
 
        UPDATE b
        SET b.v = (SELECT w.v FROM @Box AS w WHERE w.i = @j)
        FROM @Box AS b
        WHERE b.i = @i;
 
        UPDATE @Box
        SET v = @t
        WHERE i = @j;
 
        SELECT @k = b.v
        FROM @Box AS b
        WHERE b.i = @i;
 
        SELECT @k = (@k + b.v) % 256
        FROM @Box AS b
        WHERE b.i = @j;
 
        SELECT @k = b.v
        FROM @Box AS b
        WHERE b.i = @k;
 
        SELECT
            @CipherBy = CONVERT(tinyint, SUBSTRING(@Text, @Index, 1)) ^ @k,
            @Cipher = @Cipher + CONVERT(binary(1), @CipherBy);
 
        SET @Index += 1;
    END;
 
    RETURN @Cipher;
END;
GO













--Example 

Create Or Alter View V2([Shelf Code], [Number Of Books])
With Encryption
As 
	Select Code, Count(B.Id)
	From Book B Inner Join Shelf sh on sh.Code = B.Shelf_code
	Group By Code

Select * From V2





-- *** DAC connection required! ***
-- Make sure the target database is the context

DECLARE
    -- Note: OBJECT_ID only works for schema-scoped objects
    @objectid integer = OBJECT_ID(N'dbo.V2', N'V'),
    @family_guid binary(16),
    @objid binary(4),
    @subobjid binary(2),
    @imageval varbinary(MAX),
    @RC4key binary(20);
 
-- Find the database family GUID
SELECT @family_guid = CONVERT(binary(16), DRS.family_guid)
FROM sys.database_recovery_status AS DRS
WHERE DRS.database_id = DB_ID();
 
-- Convert object ID to little-endian binary(4)
SET @objid = CONVERT(binary(4), REVERSE(CONVERT(binary(4), @objectid)));
 
SELECT
    -- Read the encrypted value
    @imageval = SOV.imageval,
    -- Get the subobjid and convert to little-endian binary
    @subobjid = CONVERT(binary(2), REVERSE(CONVERT(binary(2), SOV.subobjid)))
FROM sys.sysobjvalues AS SOV
WHERE 
    SOV.[objid] = @objectid
    AND SOV.valclass = 1;
 
-- Compute the RC4 initialization key
SET @RC4key = HASHBYTES('SHA1', @family_guid + @objid + @subobjid);
 
-- Apply the standard RC4 algorithm and
-- convert the result back to nvarchar
SELECT CONVERT
    (
        nvarchar(MAX),
        dbo.fnEncDecRc4
        (
            @RC4key,
            @imageval
        )
    );