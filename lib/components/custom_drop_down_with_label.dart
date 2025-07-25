import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart' hide CarouselController;

class CustomDropDownWithLabel extends StatelessWidget {
  const CustomDropDownWithLabel({
    super.key,
    required this.label,
    Color? labelColor,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.isLlabelBold = false,
    this.isShowLabel = true,
    this.searchable = false,
    this.isEnabled =
        true, // Parameter baru untuk mengontrol status enabled/disabled
  }) : labelColor = labelColor ?? Colors.black;

  final String label;
  final bool isLlabelBold;
  final bool isShowLabel;
  final Color labelColor;
  final String selectedValue;
  final List<DropdownMenuItem<dynamic>> items;
  final Function(dynamic) onChanged;
  final bool searchable;
  final bool isEnabled; // Parameter baru

  @override
  Widget build(BuildContext context) {
    TextEditingController searchEditingController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isShowLabel)
          Text(
            label,
            style: TextStyle(
                fontSize: 14,
                color: labelColor,
                fontWeight: isLlabelBold ? FontWeight.bold : FontWeight.normal),
          ),
        const SizedBox(height: 4),
        DropdownButton2(
          isExpanded: true,
          dropdownSearchData: searchable
              ? DropdownSearchData(
                  searchController: searchEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      minLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      controller: searchEditingController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        hintText: 'Search for an item...',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    // Extract the text from the DropdownMenuItem
                    final itemText = (item.child as Text).data ?? '';
                    // Perform a case-insensitive comparison
                    return itemText
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  })
              : null,
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(20),
            ),
            height: 50,
          ),
          underline: Container(height: 0),
          hint: Text(
            "Select $label",
            style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                overflow: TextOverflow.ellipsis),
          ),
          value: selectedValue.isEmpty ? null : selectedValue,
          items: items,
          onChanged: isEnabled ? onChanged : null,
          disabledHint: Text(
            "Select $label",
            style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}
