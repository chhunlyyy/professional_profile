import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileListLoadingWidget extends StatelessWidget {
  const ProfileListLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: List.generate(2, (index) {
      return Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.6,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.9,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }
}
