﻿// <auto-generated />
using System;
using InheritanceMapping.Contexts;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace InheritanceMapping.Migrations
{
    [DbContext(typeof(InheritanceTestDbContext))]
    [Migration("20230918215717_TPH")]
    partial class TPH
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "6.0.15")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder, 1L, 1);

            modelBuilder.Entity("InheritanceMapping.Entities.Employee", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"), 1L, 1);

                    b.Property<string>("Address")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("Age")
                        .HasColumnType("int");

                    b.Property<string>("Discriminator")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("Emloyees");

                    b.HasDiscriminator<string>("Discriminator").HasValue("Employee");
                });

            modelBuilder.Entity("InheritanceMapping.Entities.FullTime", b =>
                {
                    b.HasBaseType("InheritanceMapping.Entities.Employee");

                    b.Property<decimal>("Salary")
                        .HasColumnType("money");

                    b.Property<DateTime>("StartDate")
                        .HasColumnType("datetime2");

                    b.ToTable("Emloyees");

                    b.HasDiscriminator().HasValue("FullTime");
                });

            modelBuilder.Entity("InheritanceMapping.Entities.PartTime", b =>
                {
                    b.HasBaseType("InheritanceMapping.Entities.Employee");

                    b.Property<int>("CountHours")
                        .HasColumnType("int");

                    b.Property<decimal>("HoureRate")
                        .HasColumnType("decimal(12,4)");

                    b.ToTable("Emloyees");

                    b.HasDiscriminator().HasValue("PartTime");
                });
#pragma warning restore 612, 618
        }
    }
}
