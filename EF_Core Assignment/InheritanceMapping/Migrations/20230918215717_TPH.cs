using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace InheritanceMapping.Migrations
{
    public partial class TPH : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FullTimeEmployees");

            migrationBuilder.DropPrimaryKey(
                name: "PK_PartTimeEmployees",
                table: "PartTimeEmployees");

            migrationBuilder.RenameTable(
                name: "PartTimeEmployees",
                newName: "Emloyees");

            migrationBuilder.AlterColumn<decimal>(
                name: "HoureRate",
                table: "Emloyees",
                type: "decimal(12,4)",
                nullable: true,
                oldClrType: typeof(decimal),
                oldType: "decimal(12,4)");

            migrationBuilder.AlterColumn<int>(
                name: "CountHours",
                table: "Emloyees",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<string>(
                name: "Discriminator",
                table: "Emloyees",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<decimal>(
                name: "Salary",
                table: "Emloyees",
                type: "money",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "StartDate",
                table: "Emloyees",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_Emloyees",
                table: "Emloyees",
                column: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Emloyees",
                table: "Emloyees");

            migrationBuilder.DropColumn(
                name: "Discriminator",
                table: "Emloyees");

            migrationBuilder.DropColumn(
                name: "Salary",
                table: "Emloyees");

            migrationBuilder.DropColumn(
                name: "StartDate",
                table: "Emloyees");

            migrationBuilder.RenameTable(
                name: "Emloyees",
                newName: "PartTimeEmployees");

            migrationBuilder.AlterColumn<decimal>(
                name: "HoureRate",
                table: "PartTimeEmployees",
                type: "decimal(12,4)",
                nullable: false,
                defaultValue: 0m,
                oldClrType: typeof(decimal),
                oldType: "decimal(12,4)",
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "CountHours",
                table: "PartTimeEmployees",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_PartTimeEmployees",
                table: "PartTimeEmployees",
                column: "Id");

            migrationBuilder.CreateTable(
                name: "FullTimeEmployees",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Address = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Age = table.Column<int>(type: "int", nullable: true),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Salary = table.Column<decimal>(type: "money", nullable: false),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FullTimeEmployees", x => x.Id);
                });
        }
    }
}
