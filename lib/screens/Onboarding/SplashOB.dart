import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';

class CalendarOnboarding extends StatelessWidget {
  const CalendarOnboarding({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoOnboarding(
      bottomButtonColor: CupertinoColors.systemRed.resolveFrom(context),
      onPressedOnLastPage: () => Navigator.pop(context),
      pages: [
        WhatsNewPage(
          title: const Text("What's New in Calendar"),
          features: [
            WhatsNewFeature(
              icon: Icon(
                CupertinoIcons.mail,
                color: CupertinoColors.systemRed.resolveFrom(context),
              ),
              title: const Text('Found Events'),
              description: const Text(
                'Siri suggests events found in Mail, Messages, and Safari, so you can add them easily, such as flight reservations and hotel bookings.',
              ),
            ),
            WhatsNewFeature(
              icon: Icon(
                CupertinoIcons.time,
                color: CupertinoColors.systemRed.resolveFrom(context),
              ),
              title: const Text('Time to Leave'),
              description: const Text(
                "Calendar uses Apple Maps to look up locations, traffic conditions, and transit options to tell you when it's time to leave.",
              ),
            ),
            WhatsNewFeature(
              icon: Icon(
                CupertinoIcons.location,
                color: CupertinoColors.systemRed.resolveFrom(context),
              ),
              title: const Text('Location Suggestions'),
              description: const Text(
                'Calendar suggests locations based on your past events and significant locations.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}