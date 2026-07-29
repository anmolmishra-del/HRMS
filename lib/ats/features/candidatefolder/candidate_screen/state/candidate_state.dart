class ProfileState {
  final bool loading;
  final String? pdfUrl;
  final String? sessionToken;
  final bool isShortlisted;
  final bool isRejected;

  const ProfileState({
    this.loading = false,
    this.pdfUrl,
    this.sessionToken,
    this.isShortlisted = false,
    this.isRejected = false,
  });

  ProfileState copyWith({
    bool? loading,
    String? pdfUrl,
    String? sessionToken,
    bool? isShortlisted,
    bool? isRejected,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      sessionToken: sessionToken ?? this.sessionToken,
      isShortlisted: isShortlisted ?? this.isShortlisted,
      isRejected: isRejected ?? this.isRejected,
    );
  }
}
