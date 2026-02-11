/// This class is used in the [ServicesHomeScreen] screen.

// ignore_for_file: must_be_immutable
class ServicesHomeModel {
  ServicesHomeModel({
    this.welcomeText,
    this.subText,
    this.activeServicesCount,
    this.membersCount,
    this.exploreTitle,
    this.exploreSubtitle,
  }) {
    welcomeText = welcomeText ?? "Hey there!";
    subText = subText ?? "What are you looking for today?";
    activeServicesCount = activeServicesCount ?? "9 Available";
    membersCount = membersCount ?? "15000+";
    exploreTitle = exploreTitle ?? "Explore Services";
    exploreSubtitle = exploreSubtitle ?? "Tap to discover more";
  }

  String? welcomeText;
  String? subText;
  String? activeServicesCount;
  String? membersCount;
  String? exploreTitle;
  String? exploreSubtitle;
}
