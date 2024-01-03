
using EF_Core_Assignment_01.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.Reflection.Emit;

namespace EF_Core_Assignment_01.Configuration
{
    internal class DepartmentConfiguration : IEntityTypeConfiguration<Department>
    {
        public void Configure(EntityTypeBuilder<Department> builder)
        {

            // Fluent APIs
            builder.ToTable("Departments", "dbo");

            builder.HasKey(D => D.DeptId);

            builder.Property(d => d.DeptId)
            .UseIdentityColumn(10, 10);

            builder.Property(d => d.Name)
            .HasColumnName("DepartmentName")
            .HasColumnType("varchar")
            .HasMaxLength(50)
            .IsRequired(true)
            .HasAnnotation("StringLength", "(50, MinimumLength = 10)"); // Use A specific Data Annotation

            builder.Property(d => d.DateOfCreation)
            //.HasDefaultValue(DateTime.Now) // Wrong Will Give Defaul Date of Migration
            .HasDefaultValueSql("GetDate()");

        }
    }
}
