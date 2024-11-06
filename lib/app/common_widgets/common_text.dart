import 'package:salon_user/app/utils/all_dependency.dart';

class SText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final double size;
  final FontWeight? fontWeight;
  final Color? color;
  const SText(
    this.text, {
    super.key,
    this.textAlign,
    required this.size,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        height: 1.2,
        fontWeight: fontWeight,
        fontSize: size,
        color: color ?? AppColor.grey100,
      ),
    );
  }
}

class S16Text extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;
  const S16Text(
    this.text, {
    super.key,
    this.textAlign,
    this.fontWeight,
    this.color,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines ?? 100,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: 16,
        color: color ?? AppColor.grey80,
      ),
    );
  }
}

class S18Text extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;
  const S18Text(
    this.text, {
    super.key,
    this.textAlign,
    this.fontWeight,
    this.color,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines ?? 100,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.w700,
        fontSize: 18,
        color: color ?? AppColor.grey100,
      ),
    );
  }
}

class S14Text extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;

  const S14Text(
    this.text, {
    super.key,
    this.textAlign,
    this.fontWeight,
    this.color,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines ?? 100,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: 14,
        height: 1.2,
        color: color ?? AppColor.grey80,
      ),
    );
  }
}

class S12Text extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;
  const S12Text(
    this.text, {
    super.key,
    this.textAlign,
    this.fontWeight,
    this.color,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines ?? 100,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: 12,
        height: 1.2,
        color: color ?? AppColor.grey80,
      ),
    );
  }
}

class S24Text extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final Color? color;
  const S24Text(
    this.text, {
    super.key,
    this.textAlign,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.bold,
        fontSize: 24,
        color: color ?? AppColor.grey100,
      ),
    );
  }
}
