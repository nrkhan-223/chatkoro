class Message {
  Message({
    required this.msg,
    required this.read,
    required this.fromId,
    required this.toId,
    required this.type,
    required this.send,
  });
  late final String msg;
  late final String read;
  late final String fromId;
  late final String toId;
  late final Type type;
  late final String send;

  Message.fromJson(Map<String, dynamic> json){
    msg = json['msg'].toString();
    read = json['read'].toString();
    fromId = json['from_id'].toString();
    toId = json['to_id'].toString();
    type = json['type'].toString()==Type.image.name?Type.image:Type.text;
    send = json['send'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['read'] = read;
    data['from_id'] = fromId;
    data['to_id'] = toId;
    data['type'] = type.name;
    data['send'] = send;
    return data;
  }

}
enum Type{text,image}