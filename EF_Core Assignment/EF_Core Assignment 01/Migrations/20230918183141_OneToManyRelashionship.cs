using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EF_Core_Assignment_01.Migrations
{
    public partial class OneToManyRelashionship : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "DepartmentDeptId",
                schema: "dbo",
                table: "Employees",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Employees_DepartmentDeptId",
                schema: "dbo",
                table: "Employees",
                column: "DepartmentDeptId");

            migrationBuilder.AddForeignKey(
                name: "FK_Employees_Departments_DepartmentDeptId",
                schema: "dbo",
                table: "Employees",
                column: "DepartmentDeptId",
                principalSchema: "dbo",
                principalTable: "Departments",
                principalColumn: "DeptId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Employees_Departments_DepartmentDeptId",
                schema: "dbo",
                table: "Employees");

            migrationBuilder.DropIndex(
                name: "IX_Employees_DepartmentDeptId",
                schema: "dbo",
                table: "Employees");

            migrationBuilder.DropColumn(
                name: "DepartmentDeptId",
                schema: "dbo",
                table: "Employees");
        }
    }
}
