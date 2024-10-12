import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supermarket/Admin/home_admin.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => CreateEmployee()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Employee Data"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.primary,
          ), // زر الرجوع
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeAdmin(),
                )); // إجراء الرجوع عند النقر على الزر
          },
        ),
      ),
      body: FutureBuilder<List<Employee>>(
          future: EmployeeServices().getAllEmployeeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error fetching employee data: ${snapshot.error}"),
              );
            }

            if (snapshot.hasData) {
              List<Employee> data = snapshot.data!;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  data[index].avatar ??
                                      "https://www.example.com/default-avatar"),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${data[index].firstName} ${data[index].lastName}"),
                                  Text(data[index].email ?? "No Email"),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final updatedEmployee =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CreateEmployee(
                                              employee: data[index]),
                                        ),
                                      );

                                      // تحديث البيانات بعد تعديل الموظف
                                      if (updatedEmployee != null) {
                                        setState(() {
                                          data[index] = updatedEmployee;
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Are you sure you want to delete this employee?"),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await EmployeeServices()
                                                      .deleteEmployee(
                                                          data[index].id!);

                                                  // إعادة تحميل البيانات بعد الحذف
                                                  setState(() {
                                                    data.removeAt(
                                                        index); // إزالة الموظف من القائمة
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Yes"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("No"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        await EmployeeServices()
                                            .updateEmployeePartially(
                                                {'first_name': "New Name"},
                                                data[index].id!);
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.favorite_outline)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }

            return const Center(child: Text("No employees found"));
          }),
    );
  }
}

class Employee {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? avatar;

  Employee({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.avatar,
  });

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'avatar': avatar,
    };
  }
}

class EmployeeServices {
  final String baseUri = "https://reqres.in/api/";

  Future<List<Employee>> getAllEmployeeData() async {
    List<Employee> allEmployees = [];
    try {
      var response = await http.get(Uri.parse(baseUri + "users?page=2"));

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        var employees = decodedData['data'];

        for (var employee in employees) {
          allEmployees.add(Employee.fromJson(employee));
        }
        return allEmployees;
      } else {
        throw Exception(
            "Error occurred: Status code ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error occurred: ${e.toString()}");
      return [];
    }
  }

  Future<void> createEmployee(Employee employee) async {
    try {
      var response = await http.post(Uri.parse(baseUri + 'users'),
          body: jsonEncode(employee.toJson()),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode != 201) {
        throw Exception(
            "Error occurred: Status code ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error occurred: ${e.toString()}");
    }
  }

  Future<void> updateEmployeePartially(
      Map<String, dynamic> updatedData, int id) async {
    try {
      var response = await http.patch(Uri.parse(baseUri + 'users/$id'),
          body: jsonEncode(updatedData),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode != 200) {
        throw Exception(
            "Error occurred: Status code ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error occurred: ${e.toString()}");
    }
  }

  Future<void> updateEmployee(Employee employee, int id) async {
    try {
      var response = await http.put(Uri.parse(baseUri + 'users/$id'),
          body: jsonEncode(employee.toJson()),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode != 200) {
        throw Exception(
            "Error occurred: Status code ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error occurred: ${e.toString()}");
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      var response = await http.delete(Uri.parse(baseUri + 'users/$id'));

      if (response.statusCode != 204) {
        throw Exception(
            "Error occurred: Status code ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error occurred: ${e.toString()}");
    }
  }
}

class CreateEmployee extends StatefulWidget {
  final Employee? employee;
  const CreateEmployee({super.key, this.employee});

  @override
  State<CreateEmployee> createState() => _CreateEmployeeState();
}

class _CreateEmployeeState extends State<CreateEmployee> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _firstNameController.text = widget.employee!.firstName ?? "";
      _lastNameController.text = widget.employee!.lastName ?? "";
      _emailController.text = widget.employee!.email ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.employee == null ? "Add Employee" : "Update Employee"),
      ),
      body: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter employee First name";
                      }
                      return null;
                    },
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                        helperText: "Employee's First name here",
                        labelText: "First Name",
                        hintText: "Enter the employee name",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter employee Last name";
                      }
                      return null;
                    },
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                        helperText: "Employee's Last name here",
                        labelText: "Last Name",
                        hintText: "Enter the employee Last name",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter employee email";
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: const InputDecoration(
                        helperText: "Employee's email here",
                        labelText: "Email",
                        hintText: "Enter the employee email",
                        border: OutlineInputBorder()),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      Employee newEmployee = Employee(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text,
                        avatar: "https://randomuser.me/api/portraits/men/1.jpg",
                      );

                      if (widget.employee != null) {
                        await EmployeeServices()
                            .updateEmployee(newEmployee, widget.employee!.id!);
                      } else {
                        await EmployeeServices().createEmployee(newEmployee);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(widget.employee == null
                              ? "Employee added successfully"
                              : "Employee updated successfully")));

                      // تمرير الموظف الجديد أو المعدل مرة أخرى
                      Navigator.pop(context, newEmployee);
                    }
                  },
                  child: Text(widget.employee == null
                      ? "Create Employee"
                      : "Update Employee"),
                )
              ],
            ),
          )),
    );
  }
}
