/// A crisis/support contact shown on the SOS screen.
///
/// These render fully offline — no network dependency, ever — because the
/// SOS screen must work in the exact moment someone has no signal. See
/// ARCHITECTURE.md.
class SosContact {
  const SosContact({
    required this.label,
    required this.phone,
    this.description,
    this.isExample = false,
  });

  final String label;
  final String phone;
  final String? description;

  /// True for the bundled placeholder entries. The app ships with examples
  /// so the UI is never empty, but crisis lines are region-specific and a
  /// wrong number is worse than none — real deployments MUST replace these
  /// with verified, localized numbers (and ideally let the user add their
  /// own). The UI surfaces a disclaimer while any example is present.
  final bool isExample;
}

/// Bundled defaults. **Do not treat these as authoritative.** They exist
/// only so the screen renders something before the user configures their
/// own contacts and before a region-specific resource list is wired in.
const List<SosContact> defaultSosContacts = [
  SosContact(
    label: 'Emergency services',
    phone: '112',
    description: 'Verify the correct number for your country before relying on this.',
    isExample: true,
  ),
  SosContact(
    label: 'Crisis / helpline',
    phone: '',
    description: 'Add a verified local addiction or mental-health helpline.',
    isExample: true,
  ),
];
