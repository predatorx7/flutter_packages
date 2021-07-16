/// Status of a resource that is provided to the UI.
///
///
/// These are usually created by the Repository classes where they return
/// `LiveData<Resource<T>>` to pass back the latest data to the UI with its fetch status.
enum Status {
    // ignore: constant_identifier_names
    SUCCESS,
    // ignore: constant_identifier_names
    ERROR,
    // ignore: constant_identifier_names
    LOADING
}
