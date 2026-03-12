import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// 日本語の五十音順インデックスリストのデモ
void main() {
  runApp(const MaterialApp(home: JapaneseIndexingDemo(), debugShowCheckedModeBanner: false));
}

/// 1. 日本語インデックスユーティリティ
class JapaneseIndexUtil {
  /// インデックスバーに表示する行のリスト
  static const List<String> indexList = ["あ", "か", "さ", "た", "な", "は", "ま", "や", "ら", "わ", "#"];

  /// 読み仮名から対応する五十音の「行」を返す
  static String getRowTag(String phonetic) {
    if (phonetic.isEmpty) return "#";
    // 最初の文字を取得
    String firstChar = phonetic.substring(0, 1);

    // 各行に対応する文字のマップ
    const rowMap = {
      'あ': ['あ', 'い', 'う', 'え', 'お', 'ぁ', 'ぃ', 'ぅ', 'ぇ', 'ぉ', 'ア', 'イ', 'ウ', 'エ', 'オ'],
      'か': ['か', 'き', 'く', 'け', 'こ', 'が', 'ぎ', 'ぐ', 'げ', 'ご', 'カ', 'キ', 'ク', 'ケ', 'コ'],
      'さ': ['さ', 'し', 'す', 'せ', 'そ', 'ざ', 'じ', 'ず', 'ぜ', 'ぞ', 'サ', 'シ', 'ス', 'セ', 'ソ'],
      'た': ['た', 'ち', 'つ', 'て', 'と', 'だ', 'ぢ', 'づ', 'で', 'ど', 'タ', 'チ', 'ツ', 'テ', 'ト'],
      'な': ['な', 'に', 'ぬ', 'ね', 'の', 'ナ', 'ニ', 'ヌ', 'ネ', 'ノ'],
      'は': ['は', 'ひ', 'ふ', 'へ', 'ほ', 'ば', 'び', 'ぶ', 'べ', 'ぼ', 'ぱ', 'ぴ', 'ぷ', 'ぺ', 'ぽ'],
      'ま': ['ま', 'み', 'む', 'め', 'も', 'マ', 'ミ', 'ム', 'メ', 'モ'],
      'や': ['や', 'ゆ', 'よ', 'ゃ', 'ゅ', 'ょ', 'ヤ', 'ユ', 'ヨ'],
      'ら': ['ら', 'り', 'る', 'れ', 'ろ', 'ラ', 'リ', 'ル', 'レ', 'ロ'],
      'わ': ['わ', 'を', 'ん', 'ワ', 'ヲ', 'ン'],
    };

    for (var entry in rowMap.entries) {
      if (entry.value.contains(firstChar)) return entry.key;
    }
    return "#";
  }
}

/// 2. 汎用的な日本語インデックスリストコンポーネント
class JapaneseIndexListView<T> extends StatefulWidget {
  /// 表示するデータのリスト
  final List<T> data;

  /// データから読み仮名を取得するための関数
  final String Function(T) phoneticProvider;

  /// 各アイテムのウィジェットを構築する関数
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// グループヘッダーを構築するオプション関数
  final Widget Function(BuildContext context, String tag)? headerBuilder;

  /// インデックスバーのアイテムの高さ
  final double indexItemHeight;

  const JapaneseIndexListView({
    super.key,
    required this.data,
    required this.phoneticProvider,
    required this.itemBuilder,
    this.headerBuilder,
    this.indexItemHeight = 22.0,
  });

  @override
  State<JapaneseIndexListView<T>> createState() => _JapaneseIndexListViewState<T>();
}

class _JapaneseIndexListViewState<T> extends State<JapaneseIndexListView<T>> {
  final ItemScrollController _scrollController = ItemScrollController();
  final Map<String, int> _tagMap = {};
  late List<T> _sortedData;
  String _activeTag = "";
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    _prepareData();
  }

  @override
  void didUpdateWidget(JapaneseIndexListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // データが変更された場合に再準備
    if (oldWidget.data != widget.data) _prepareData();
  }

  /// データのソートとインデックスマップの作成
  void _prepareData() {
    _sortedData = List.from(widget.data);
    _tagMap.clear();

    // 読み仮名順にソート
    _sortedData.sort((a, b) {
      return widget.phoneticProvider(a).compareTo(widget.phoneticProvider(b));
    });

    // 各行の開始位置をマップに保存
    for (int i = 0; i < _sortedData.length; i++) {
      String tag = JapaneseIndexUtil.getRowTag(widget.phoneticProvider(_sortedData[i]));
      if (!_tagMap.containsKey(tag)) _tagMap[tag] = i;
    }
  }

  /// インデックスがタッチされた際の処理
  void _onIndexTouch(String tag) {
    if (_tagMap.containsKey(tag)) {
      _scrollController.jumpTo(index: _tagMap[tag]!);
      HapticFeedback.selectionClick();
      setState(() {
        _activeTag = tag;
        _showOverlay = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // メインリスト
        ScrollablePositionedList.builder(
          itemCount: _sortedData.length,
          itemScrollController: _scrollController,
          itemBuilder: (context, index) {
            final item = _sortedData[index];
            final String phonetic = widget.phoneticProvider(item);
            final String tag = JapaneseIndexUtil.getRowTag(phonetic);

            // 前のアイテムと行が異なる場合にヘッダーを表示
            final bool isFirstInGroup =
                index == 0 ||
                JapaneseIndexUtil.getRowTag(widget.phoneticProvider(_sortedData[index - 1])) != tag;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isFirstInGroup) widget.headerBuilder?.call(context, tag) ?? _defaultHeader(tag),
                widget.itemBuilder(context, item),
              ],
            );
          },
        ),
        // 右側のインデックスバー
        Align(
          alignment: Alignment.centerRight,
          child: _IndexBar(
            onTouch: _onIndexTouch,
            onTouchEnd: () => setState(() => _showOverlay = false),
            tagMap: _tagMap,
            itemHeight: widget.indexItemHeight,
          ),
        ),
        // 中央のオーバーレイ提示
        if (_showOverlay) _buildCenterOverlay(),
      ],
    );
  }

  /// デフォルトのグループヘッダー
  Widget _defaultHeader(String tag) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    color: Colors.grey[100],
    child: Text(
      tag,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
    ),
  );

  /// 中央に表示される現在のタグプレビュー
  Widget _buildCenterOverlay() => Center(
    child: Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
      alignment: Alignment.center,
      child: Text(
        _activeTag,
        style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

/// 3. インデックスバーコンポーネント
class _IndexBar extends StatelessWidget {
  final Function(String) onTouch;
  final VoidCallback onTouchEnd;
  final Map<String, int> tagMap;
  final double itemHeight;

  const _IndexBar({
    required this.onTouch,
    required this.onTouchEnd,
    required this.tagMap,
    required this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // タッチ位置からインデックスを計算
        int index = (details.localPosition.dy / itemHeight).floor();
        if (index >= 0 && index < JapaneseIndexUtil.indexList.length) {
          onTouch(JapaneseIndexUtil.indexList[index]);
        }
      },
      onVerticalDragEnd: (_) => onTouchEnd(),
      onTapDown: (details) {
        int index = (details.localPosition.dy / itemHeight).floor();
        if (index >= 0 && index < JapaneseIndexUtil.indexList.length) {
          onTouch(JapaneseIndexUtil.indexList[index]);
        }
      },
      onTapUp: (_) => onTouchEnd(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: JapaneseIndexUtil.indexList.map((tag) {
            final bool hasData = tagMap.containsKey(tag);
            return SizedBox(
              height: itemHeight,
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: hasData ? Colors.blueAccent : Colors.grey[300],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// 4. 利用例（呼び出し側）
class JapaneseIndexingDemo extends StatelessWidget {
  const JapaneseIndexingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // 外部から渡されるデータ例
    final List<Map<String, String>> contacts = [
      {"name": "安倍 晋三", "reading": "あべ しんぞう"},
      {"name": "伊藤 博文", "reading": "いとう ひろぶみ"},
      {"name": "上野 樹里", "reading": "うえの じゅり"},
      {"name": "加藤 剛", "reading": "かとう ごう"},
      {"name": "木村 拓哉", "reading": "きむら たくや"},
      {"name": "佐藤 健", "reading": "さとう たける"},
      {"name": "鈴木 亮平", "reading": "すずき りょうへい"},
      {"name": "田中 圭", "reading": "たなか けい"},
      {"name": "中島 美嘉", "reading": "なかじま みか"},
      {"name": "橋本 環奈", "reading": "はしもと かんな"},
      {"name": "本田 翼", "reading": "ほんだ つばさ"},
      {"name": "松本 潤", "reading": "まつもと じゅん"},
      {"name": "山崎 賢人", "reading": "やまざき けんと"},
      {"name": "渡辺 謙", "reading": "わたなべ けん"},
      {"name": "Apple Store", "reading": "apple store"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("日本語インデックスリスト"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: JapaneseIndexListView<Map<String, String>>(
        data: contacts,
        // アイテムから読み仮名を取得するロジックを渡す
        phoneticProvider: (item) => item["reading"]!,
        // アイテムの見た目を定義
        itemBuilder: (context, item) => ListTile(
          title: Text(item["name"]!, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(item["reading"]!, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          onTap: () => print("Selected: ${item["name"]}"),
        ),
        // オプション: ヘッダーのカスタマイズ
        headerBuilder: (context, tag) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          color: Colors.blueAccent.withOpacity(0.05),
          child: Text(
            tag,
            style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
