// TODO: release build must implement the API_ENDPOINT env variable
const APIENDPOINT = String.fromEnvironment('API_ENDPOINT',
    defaultValue: "http://10.0.2.2:3000");

const spUserInfoKey = "MY_CLUSER";

enum Badge {
  Daily3,
  Daily5,
  Daily10,
  Daily30,
  Techie,
}
