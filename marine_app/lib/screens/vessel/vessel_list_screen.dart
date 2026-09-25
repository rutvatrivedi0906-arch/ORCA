import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/fisherman_models.dart';
import '../../services/fisherman_service.dart';
import 'vessel_form_screen.dart';

class VesselListScreen extends StatefulWidget {
  const VesselListScreen({super.key});

  @override
  State<VesselListScreen> createState() => _VesselListScreenState();
}

class _VesselListScreenState extends State<VesselListScreen> {
  bool loading = true;
  String? error;
  List<VesselData> vessels = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final result = await FishermanService.getVessels();

      if (!mounted) return;

      setState(() => vessels = result);
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> _openForm([VesselData? vessel]) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => VesselFormScreen(vessel: vessel)),
    );

    if (changed == true) {
      await _load();
    }
  }

  Future<void> _delete(VesselData vessel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete vessel?'),
          content: Text('Remove "${vessel.name}" from your ORCA account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await FishermanService.deleteVessel(vessel.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Vessel deleted.')));

      await _load();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FA),
      appBar: AppBar(
        title: const Text('My Vessels'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppTheme.navy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Vessel'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? _errorView()
          : vessels.isEmpty
          ? _emptyView()
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 110),
                itemCount: vessels.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _vesselCard(vessels[index]);
                },
              ),
            ),
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 46,
              color: AppTheme.oceanBlue,
            ),
            const SizedBox(height: 12),
            Text(error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sailing_rounded,
              size: 58,
              color: AppTheme.oceanBlue,
            ),
            const SizedBox(height: 16),
            const Text(
              'No vessel added yet',
              style: TextStyle(
                color: AppTheme.navy,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your vessel once so ORCA can reuse its '
              'speed, dimensions and usual persons onboard '
              'for future trip planning and safety workflows.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF687D87), height: 1.45),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add My Vessel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vesselCard(VesselData vessel) {
    final details = <String>[
      if (vessel.vesselType != null) vessel.vesselType!,
      if (vessel.cruisingSpeedKnots != null)
        '${vessel.cruisingSpeedKnots!.toStringAsFixed(1)} kn',
      '${vessel.personsOnboardDefault} person(s)',
    ].join(' • ');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDDE8EC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.oceanBlue.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.sailing_rounded, color: AppTheme.oceanBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vessel.name,
                  style: const TextStyle(
                    color: AppTheme.navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (vessel.registrationNumber != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    vessel.registrationNumber!,
                    style: const TextStyle(color: Color(0xFF6E828C)),
                  ),
                ],
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    details,
                    style: const TextStyle(
                      color: Color(0xFF6E828C),
                      fontSize: 12.5,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    TextButton.icon(
                      onPressed: () => _openForm(vessel),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit'),
                    ),
                    TextButton.icon(
                      onPressed: () => _delete(vessel),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
