import 'package:collection/collection.dart';
import 'package:contractor_app/logic/Apis/attendance_provider.dart';
import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/ui_screens/apps_screen/menu_bar/custom_drawer.dart';
import 'package:contractor_app/ui_screens/apps_screen/home/verificationScreen/map_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final projectsAsync = ref.watch(projectProviderList);
    final attendanceState = ref.watch(attendanceProvider);

    return Scaffold(
      body: projectsAsync.when(
        data: (projectModel) {
          final projects = projectModel.totalProjects ?? [];
          if (projects.isEmpty) {
            return const Center(child: Text("No projects available"));
          }

          if (attendanceState.isPunchedIn) {
            final punchedInProject = projects.firstWhereOrNull(
                (p) => p.id == attendanceState.punchedInProjectId);
            if (punchedInProject == null) {
              return const Center(child: Text("Punched in project not found"));
            }

            // Sort projects to show punched-in project first
            final sortedProjects = projects.toList();
            sortedProjects.sort((a, b) {
              if (a.id == punchedInProject.id) return -1;
              if (b.id == punchedInProject.id) return 1;
              return 0;
            });

            return ListView.builder(
              padding: EdgeInsets.all(width * 0.03),
              itemCount: sortedProjects.length,
              itemBuilder: (context, index) {
                final project = sortedProjects[index];
                return _buildProjectCard(context, project, attendanceState);
              },
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(width * 0.03),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _buildProjectCard(context, project, attendanceState);
              },
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Widget _buildProjectCard(
      BuildContext context, dynamic project, AttendanceState attendanceState) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final isThisProjectPunchedIn = attendanceState.isPunchedIn &&
        attendanceState.punchedInProjectId == project.id;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(width * 0.028),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              project.projectImageUrl != null
                  ? Image.network(
                      project.projectImageUrl!,
                      width: width * 0.25,
                      height: height * 0.16,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) =>
                          const Icon(Icons.broken_image, size: 60),
                    )
                  : Image.asset(
                      'assets/images/Elevation1.png',
                      width: width * 0.25,
                      height: height * 0.16,
                      fit: BoxFit.cover,
                    ),
              SizedBox(width: width * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name ?? "Untitled Project",
                      style: TextStyle(
                        fontSize: width * 0.037,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE85426),
                        fontFamily: 'Source Sans 3',
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(project.address ?? "No Address"),
                    Text(project.city ?? "No City"),
                    Text(project.state ?? "No State"),
                    SizedBox(height: height * 0.012),
                    if (attendanceState.isLoading)
                      const CircularProgressIndicator()
                    else
                      Row(
                        children: [
                          if (isThisProjectPunchedIn)
                            ElevatedButton(
                              onPressed: () => _navigateToPermissionScreen(
                                  context, project.id, 'punch_out'),
                              child: const Text("Punch Out",
                                  style: TextStyle(fontSize: 12)),
                            )
                          else if (!attendanceState.isPunchedIn)
                            ElevatedButton(
                              onPressed: () => _navigateToPermissionScreen(
                                  context, project.id, 'punch_in'),
                              child: const Text("Punch In",
                                  style: TextStyle(fontSize: 12)),
                            )
                          else if (attendanceState.isPunchedIn &&
                              !isThisProjectPunchedIn)
                            ElevatedButton(
                              onPressed: null,
                              child: const Text("Punch In",
                                  style: TextStyle(fontSize: 12)),
                            ),
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPermissionScreen(
      BuildContext context, int projectId, String action) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationMapScreen(),
        settings: RouteSettings(arguments: {
          'action': action,
          'projectId': projectId,
        }),
      ),
    );

    if (result == true && mounted) {
      try {
        if (action == 'punch_in') {
          await ref.read(attendanceProvider.notifier).punchIn(projectId);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Punch In Successful"),
              content: Text("You have successfully punched in."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        } else {
          await ref.read(attendanceProvider.notifier).punchOut();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Punch Out Successful"),
              content: Text("You have successfully punched out."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to $action: $e")),
        );
      }
    }
  }
}