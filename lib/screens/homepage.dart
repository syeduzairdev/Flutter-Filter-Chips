import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:practice/model/hobbies_model.dart';
import 'package:practice/provider/hobbies_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HobbiesViewModel? hobbiesViewModel;

  @override
  void initState() {
    super.initState();
    hobbiesViewModel = Provider.of<HobbiesViewModel>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      try {
        await hobbiesViewModel!.loadHobbies();
        await hobbiesViewModel!.loadHobbiesLevels();
      } catch (e) {
        SnackBar(content: Text(e.toString()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filters Chips"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => _showSelectedHobbiesDialog(context),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: Consumer<HobbiesViewModel>(
              builder: (context, model, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: model.hobbiesList.map((hobby) {
                      return FilterChip(
                        label: Text(hobby.name!),
                        selected: model.selectedHobbies.contains(hobby),
                        onSelected: (bool selected) {
                          if (selected) {
                            model.addSelectedHobby(hobby);
                            // model.setSelectedHobby(hobby);
                            _showHobbyLevelsDialog(
                                context, model.hobbiesLevelList, hobby);
                          } else {
                            // model.removeSelectedHobby(hobby);
                            model.clearSelectedLevel(hobby);

                            // model.setSelectedHobby(null);
                          }
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                hobbiesViewModel!.submitSelectedData();
              },
              child: Text("Press"))
        ],
      ),
    );
  }

  void _showSelectedHobbiesDialog(BuildContext context) {
    final viewModel = Provider.of<HobbiesViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selected Hobbies'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: viewModel.selectedHobbies.map((hobby) {
                return ListTile(
                  title: Text(hobby.name!),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void _showHobbyLevelsDialog(
    BuildContext context, List<HobbiesModel> levels, HobbiesModel hobby) {
  final viewModel = Provider.of<HobbiesViewModel>(context, listen: false);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Levels for ${hobby.name}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: levels.map((level) {
              // final isSelected = viewModel.getSelectedLevel(hobby) == level;
              return ListTile(
                title: Text(level
                    .name!), // Assuming `name` is a property in `HobbiesModel`
                // shape: RoundedRectangleBorder(
                //   side: BorderSide(
                //     color: isSelected ? Colors.blueAccent : Colors.transparent,
                //     width: 2,
                //   ),
                //   borderRadius: BorderRadius.circular(4),
                // ),
                onTap: () {
                  // Set the selected level in the ViewModel
                  viewModel.setSelectedLevel(hobby, level);
                  Navigator.of(context).pop(); // Close level dialog
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
