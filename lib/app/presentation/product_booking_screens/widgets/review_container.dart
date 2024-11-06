import 'package:salon_user/app/utils/all_dependency.dart';

class ReviewContainer extends StatelessWidget {
  const ReviewContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: AppColor.primaryLightColor,
          ),
          10.horizontal(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    S14Text(
                      "Review name",
                      color: AppColor.grey100,
                      fontWeight: FontWeight.w400,
                    ),
                    S12Text(
                      "2 days ago",
                      color: AppColor.grey60,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                5.vertical(),
                const RatingStar(rating: 3.5),
                5.vertical(),
                const ReadMoreText(
                  AppStrings.loremText,
                  isExpandable: true,
                  trimLength: 150,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.grey80,
                  ),
                  moreStyle: TextStyle(
                    color: AppColor.grey80,
                    fontWeight: FontWeight.w600,
                  ),
                  lessStyle: TextStyle(
                    color: AppColor.grey80,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
