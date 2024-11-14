import 'package:cave/cave.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class FavouriteIcon extends StatelessWidget {
  const FavouriteIcon({super.key, this.isFavourite = false, this.onTap});

  final bool isFavourite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: isFavourite ? 'Remove from favourites' : 'Add to favourites',
      ),
      child: Material(
        borderRadius: const BorderRadius.all(
            Radius.circular(Constants.smallVerticalGutter)),
        color: DevfestColors.primariesYellow90.possibleDarkVariant,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(
              Radius.circular(Constants.smallVerticalGutter)),
          child: Padding(
            padding: const EdgeInsets.all(Constants.largeVerticalGutter / 4).r,
            child: Icon(
              isFavourite ? IconsaxBold.star : IconsaxOutline.star,
              color: DevfestColors.grey50.possibleDarkVariant,
            ),
          ),
        ),
      ),
    );
  }
}
