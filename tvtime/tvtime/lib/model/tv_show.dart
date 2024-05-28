
class TvShow {
  int id;
  String name;
  String imageThumbnailPath;

  TvShow(this.id, this.name, this.imageThumbnailPath);

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      json['id'],
      json['name'],
      json['image_thumbnail_path'],
    );
  }
}