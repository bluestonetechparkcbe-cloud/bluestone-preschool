/// This class is used in the [WelcomeScreen] screen.

class WelcomeModel {
  WelcomeModel({
    this.appTitle,
    this.institutionName,
    this.tagline,
    this.educationCareer,
    this.sportsLifestyle,
    this.technologyInnovation,
    this.buttonText,
    this.socialProofText,
  }) {
    appTitle = appTitle ?? "Bluestone";
    institutionName = institutionName ?? "Group of Institutions";
    tagline = tagline ?? "Everything you need, all in one place";
    educationCareer = educationCareer ?? "Education & Career";
    sportsLifestyle = sportsLifestyle ?? "Sports & Lifestyle";
    technologyInnovation = technologyInnovation ?? "Technology & Innovation";
    buttonText = buttonText ?? "Get Started";
    socialProofText = socialProofText ?? "Join thousands of satisfied users";
  }

  String? appTitle;
  String? institutionName;
  String? tagline;
  String? educationCareer;
  String? sportsLifestyle;
  String? technologyInnovation;
  String? buttonText;
  String? socialProofText;
}
