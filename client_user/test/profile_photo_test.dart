import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_user/components/profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final photo in <String?>[
    null,
    '',
    '   ',
    'file:///',
    '/photo.jpg',
    'https://',
    'not a URL',
  ]) {
    testWidgets('Missing or invalid photo uses avatar: $photo', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SizedBox(
          width: 80,
          height: 80,
          child: ProfilePhoto(photo: photo),
        ),
      ));

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Valid URL retains caching and provides an error fallback',
      (tester) async {
    const url = 'https://firebasestorage.googleapis.com/v0/b/example/o/photo';
    late CachedNetworkImage image;
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        image = const ProfilePhoto(photo: ' $url ').build(context)
            as CachedNetworkImage;
        return image.errorWidget!(context, url, Exception('Download failed'));
      }),
    ));

    expect(image.imageUrl, url);
    expect(image.fit, BoxFit.cover);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
