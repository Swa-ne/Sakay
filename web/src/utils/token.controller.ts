class TokenController {
  updateAccessToken(token: string) {
    localStorage.setItem("Access Token", token);
  }

  updateUserID(userId: string) {
    localStorage.setItem("User ID", userId);
  }

  updateUserType(userType: string) {
    localStorage.setItem("User Type", userType);
  }

  updateFirstName(firstName: string) {
    localStorage.setItem("First Name", firstName);
  }

  updateLastName(lastName: string) {
    localStorage.setItem("Last Name", lastName);
  }

  updateEmail(email: string) {
    localStorage.setItem("Email", email);
  }

  updateProfile(profile: string) {
    localStorage.setItem("Profile", profile);
  }

  updateFirstTime(toggle: string) {
    localStorage.setItem("First Time", toggle);
  }

  removeAccessToken() {
    localStorage.removeItem("Access Token");
  }

  removeUserID() {
    localStorage.removeItem("User ID");
  }

  removeUserType() {
    localStorage.removeItem("User Type");
  }

  removeFirstName() {
    localStorage.removeItem("First Name");
  }

  removeLastName() {
    localStorage.removeItem("Last Name");
  }

  removeEmail() {
    localStorage.removeItem("Email");
  }

  removeProfile() {
    localStorage.removeItem("Profile");
  }

  removeFirstTime() {
    localStorage.removeItem("First Time");
  }

  getAccessToken() {
    return localStorage.getItem("Access Token") ?? "";
  }

  getUserID(): string {
    return localStorage.getItem("User ID") ?? "";
  }

  getUserType(): string {
    return localStorage.getItem("User Type") ?? "";
  }

  getFirstName(): string {
    return localStorage.getItem("First Name") ?? "";
  }

  getLastName(): string {
    return localStorage.getItem("Last Name") ?? "";
  }

  getEmail(): string {
    return localStorage.getItem("Email") ?? "";
  }

  getProfile(): string {
    return localStorage.getItem("Profile") ?? "";
  }

  getFirstTime(): string {
    return localStorage.getItem("First Time") ?? "";
  }
}

export default TokenController;
