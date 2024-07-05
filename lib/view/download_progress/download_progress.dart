import 'package:avaz_app/common/common_text_field_widget.dart';
import 'package:avaz_app/util/app_color_constants.dart';
import 'package:flutter/material.dart';

class DownloadProgress extends StatefulWidget {
  const DownloadProgress({super.key});

  @override
  State<DownloadProgress> createState() => _DownloadProgressState();
}

class _DownloadProgressState extends State<DownloadProgress> {
  @override
  Widget build(BuildContext context) {
    return const KeyboardScreen();
  }
}

class KeyboardScreen extends StatelessWidget {
  const KeyboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.baseBG,
      body: Column(
        children: [
          Container(
            color: AppColorConstants.topRowBackground,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: CommonTextFieldWidget(
                  textFieldHeight: 70,
                  controller: TextEditingController(),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: AppColorConstants.keyRowBackground,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTopKey('i'),
                  _buildTopKey('I'),
                  _buildTopKey('😊'),
                  _buildTopKey('Yes'),
                  _buildTopKey('the'),
                  _buildTopKey('the'),
                  _buildTopKey('🔴'),
                  _buildTopKey('it'),
                  _buildTopKey('❓'),
                  _buildTopKey('what'),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: GridView.count(
              crossAxisCount: 10,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              children: List.generate(30, (index) {
                return _buildKey((index % 10).toString());
              }),
            ),
          ),
          Container(
            height: 80,
            color: AppColorConstants.keyRowBackground,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomKey(Icons.favorite, 'Favourites'),
                _buildBottomKey(Icons.save, 'Save'),
                const Spacer(),
                _buildBottomKey(Icons.backspace, ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopKey(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      color: AppColorConstants.keyBackground,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColorConstants.keyTextColor,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildKey(String label) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      color: AppColorConstants.keyBackground,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: AppColorConstants.keyTextColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomKey(IconData icon, String label) {
    return Container(
      color: AppColorConstants.keyBackground,
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColorConstants.keyTextColor),
          if (label.isNotEmpty)
            Text(
              label,
              style: const TextStyle(
                color: AppColorConstants.keyTextColor,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}
