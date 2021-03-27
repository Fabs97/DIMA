// TODO: release build must implement the API_ENDPOINT env variable
const APIENDPOINT = String.fromEnvironment('API_ENDPOINT',
    defaultValue: "http://10.0.2.2:3000");

const spUserInfoKey = "MY_CLUSER";

const String techText =
    "A technical user is someone who has a deeper knowledge regarding architecture and city maintainability." +
        "\n\nExamples of technical users can be people who (are about to) graduate in Civil Engineering, Architecture or some related/similar faculty";

enum Badge {
  Daily3,
  Daily5,
  Daily10,
  Daily30,
  Techie,
  Structural1,
  Structural5,
  Structural10,
  Structural25,
  Structural50,
  Emotional1,
  Emotional5,
  Emotional10,
  Emotional25,
  Emotional50,
}
