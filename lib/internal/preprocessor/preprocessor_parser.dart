// This code was generated by a tool.
// Processing tool available at https://github.com/mezoni/peg

class PreprocessorParser {
  static final List<String> _ascii = new List<String>.generate(128, (c) => new String.fromCharCode(c));
  
  static final List<String> _expect0 = <String>["IfPart"];
  
  static final List<String> _expect1 = <String>["IfLine"];
  
  static final List<String> _expect10 = <String>[null];
  
  static final List<String> _expect11 = <String>["\'#\'"];
  
  static final List<String> _expect12 = <String>["define", "elif", "else", "endif", "fndef", "ifdef", "undef"];
  
  static final List<String> _expect13 = <String>["Spacing"];
  
  static final List<String> _expect2 = <String>["\'#elif\'"];
  
  static final List<String> _expect3 = <String>["ConstantExpression"];
  
  static final List<String> _expect4 = <String>["IDENT_START"];
  
  static final List<String> _expect5 = <String>["IDENT_CONT"];
  
  static final List<String> _expect6 = <String>["Identifier"];
  
  static final List<String> _expect7 = <String>["\'#else\'"];
  
  static final List<String> _expect8 = <String>["\'#endif\'"];
  
  static final List<String> _expect9 = <String>["Text"];
  
  static final List<bool> _lookahead = _unmap([0x7ffe03ff, 0x7ffd0fff, 0x1fff]);
  
  static final List<bool> _mapping0 = _unmap([0x43ffffff, 0x7fffffe]);
  
  static final List<bool> _mapping1 = _unmap([0x800001]);
  
  static final List<int> _strings0 = <int>[35, 105, 102];
  
  static final List<int> _strings1 = <int>[35, 105, 102, 100, 101, 102];
  
  static final List<int> _strings10 = <int>[102, 110, 100, 101, 102];
  
  static final List<int> _strings11 = <int>[105, 102, 100, 101, 102];
  
  static final List<int> _strings12 = <int>[117, 110, 100, 101, 102];
  
  static final List<int> _strings2 = <int>[35, 105, 102, 110, 100, 101, 102];
  
  static final List<int> _strings3 = <int>[35, 101, 108, 105, 102];
  
  static final List<int> _strings4 = <int>[35, 101, 108, 115, 101];
  
  static final List<int> _strings5 = <int>[35, 101, 110, 100, 105, 102];
  
  static final List<int> _strings6 = <int>[100, 101, 102, 105, 110, 101];
  
  static final List<int> _strings7 = <int>[101, 108, 105, 102];
  
  static final List<int> _strings8 = <int>[101, 108, 115, 101];
  
  static final List<int> _strings9 = <int>[101, 110, 100, 105, 102];
  
  final List<int> _tokenFlags = [1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1];
  
  final List<String> _tokenNames = ["IfPart", "IfLine", "\'#elif\'", "\'#elif\'", "ConstantExpression", "IDENT_START", "IDENT_CONT", "Identifier", "\'#else\'", "\'#else\'", "\'#endif\'", "Text", "\'#\'", "Spacing"];
  
  static final List<List<int>> _transitions0 = [[65, 90, 95, 95, 97, 122]];
  
  static final List<List<int>> _transitions1 = [[48, 57], [65, 90, 95, 95, 97, 122]];
  
  static final List<List<int>> _transitions2 = [[100, 100], [101, 101], [102, 102], [105, 105], [117, 117]];
  
  List _cache;
  
  int _cachePos;
  
  List<int> _cacheRule;
  
  List<int> _cacheState;
  
  int _ch;
  
  int _cursor;
  
  List<PreprocessorParserError> _errors;
  
  List<String> _expected;
  
  int _failurePos;
  
  List<int> _input;
  
  int _inputLen;
  
  int _startPos;
  
  int _testing;
  
  int _token;
  
  int _tokenLevel;
  
  int _tokenStart;
  
  bool success;
  
  final String text;
  
  PreprocessorParser(this.text) {
    if (text == null) {
      throw new ArgumentError('text: $text');
    }    
    _input = _toCodePoints(text);
    _inputLen = _input.length;
    if (_inputLen >= 0x3fffffe8 / 32) {
      throw new StateError('File size to big: $_inputLen');
    }  
    reset(0);    
  }
  
  void _beginToken(int tokenId) {
    if (_tokenLevel++ == 0) {
      _token = tokenId;
      _tokenStart = _cursor;
    }  
  }
  
  void _endToken() {
    if (--_tokenLevel == 0) {
      _token = null;
      _tokenStart = null;
    }    
  }
  
  void _failure([List<String> expected]) {  
    if (_failurePos > _cursor) {
      return;
    }
    if (_failurePos < _cursor) {    
      _expected = [];
     _failurePos = _cursor;
    }
    if (_token != null) {
      var flag = _tokenFlags[_token];
      var name = _tokenNames[_token];
      if (_failurePos == _inputLen && (flag & 1) != 0) {             
        var message = "Unterminated $name";
        _errors.add(new PreprocessorParserError(PreprocessorParserError.UNTERMINATED, _failurePos, _tokenStart, message));            
      }
      else if (_failurePos > _tokenStart && (flag & 1) != 0) {             
        var message = "Malformed $name";
        _errors.add(new PreprocessorParserError(PreprocessorParserError.MALFORMED, _failurePos, _tokenStart, message));            
      }
      _expected.add(name);        
    } else if (expected == null) {
      _expected.add(null);
    } else {
      _expected.addAll(expected);
    }   
  }
  
  List _flatten(dynamic value) {
    if (value is List) {
      var result = [];
      var length = value.length;
      for (var i = 0; i < length; i++) {
        var element = value[i];
        if (element is Iterable) {
          result.addAll(_flatten(element));
        } else {
          result.add(element);
        }
      }
      return result;
    } else if (value is Iterable) {
      var result = [];
      for (var element in value) {
        if (element is! List) {
          result.add(element);
        } else {
          result.addAll(_flatten(element));
        }
      }
    }
    return [value];
  }
  
  int _getState(List<List<int>> transitions) {
    var count = transitions.length;
    var state = 0;
    for ( ; state < count; state++) {
      var found = false;
      var ranges = transitions[state];    
      while (true) {
        var right = ranges.length ~/ 2;
        if (right == 0) {
          break;
        }
        var left = 0;
        if (right == 1) {
          if (_ch <= ranges[1] && _ch >= ranges[0]) {
            found = true;          
          }
          break;
        }
        int middle;
        while (left < right) {
          middle = (left + right) >> 1;
          var index = middle << 1;
          if (ranges[index + 1] < _ch) {
            left = middle + 1;
          } else {
            if (_ch >= ranges[index]) {
              found = true;
              break;
            }
            right = middle;
          }
        }
        break;
      }
      if (found) {
        return state; 
      }   
    }
    if (_ch != -1) {
      return state;
    }
    return state + 1;  
  }
  
  List _list(Object first, List next) {
    var length = next.length;
    var list = new List(length + 1);
    list[0] = first;
    for (var i = 0; i < length; i++) {
      list[i + 1] = next[i][1];
    }
    return list;
  }
  
  String _matchAny() {
    success = _cursor < _inputLen;
    if (success) {
      String result;
      if (_ch < 128) {
        result = _ascii[_ch];  
      } else {
        result = new String.fromCharCode(_ch);
      }    
      if (++_cursor < _inputLen) {
        _ch = _input[_cursor];
      } else {
        _ch = -1;
      }    
      return result;
    }    
    return null;  
  }
  
  String _matchChar(int ch, String string) {
    success = _ch == ch;
    if (success) {
      var result = string;  
      if (++_cursor < _inputLen) {
        _ch = _input[_cursor];
      } else {
        _ch = -1;
      }    
      return result;
    }  
    return null;  
  }
  
  String _matchMapping(int start, int end, List<bool> mapping) {
    success = _ch >= start && _ch <= end;
    if (success) {    
      if(mapping[_ch - start]) {
        String result;
        if (_ch < 128) {
          result = _ascii[_ch];  
        } else {
          result = new String.fromCharCode(_ch);
        }     
        if (++_cursor < _inputLen) {
          _ch = _input[_cursor];
        } else {
          _ch = -1;
        }      
        return result;
      }
      success = false;
    }  
    return null;  
  }
  
  String _matchRange(int start, int end) {
    success = _ch >= start && _ch <= end;
    if (success) {
      String result;
      if (_ch < 128) {
        result = _ascii[_ch];  
      } else {
        result = new String.fromCharCode(_ch);
      }        
      if (++_cursor < _inputLen) {
        _ch = _input[_cursor];
      } else {
        _ch = -1;
      }  
      return result;
    }  
    return null;  
  }
  
  String _matchRanges(List<int> ranges) {
    var length = ranges.length;
    for (var i = 0; i < length; i += 2) {    
      if (_ch >= ranges[i]) {
        if (_ch <= ranges[i + 1]) {
          String result;
          if (_ch < 128) {
            result = _ascii[_ch];  
          } else {
            result = new String.fromCharCode(_ch);
          }          
          if (++_cursor < _inputLen) {
            _ch = _input[_cursor];
          } else {
             _ch = -1;
          }
          success = true;    
          return result;
        }      
      } else break;  
    }
    success = false;  
    return null;  
  }
  
  String _matchString(List<int> codePoints, String string) {
    var length = codePoints.length;  
    success = _cursor + length <= _inputLen;
    if (success) {
      for (var i = 0; i < length; i++) {
        if (codePoints[i] != _input[_cursor + i]) {
          success = false;
          break;
        }
      }
    } else {
      success = false;
    }  
    if (success) {
      _cursor += length;      
      if (_cursor < _inputLen) {
        _ch = _input[_cursor];
      } else {
        _ch = -1;
      }    
      return string;      
    }  
    return null; 
  }
  
  void _nextChar() {
    if (++_cursor < _inputLen) {
      _ch = _input[_cursor];
    } else {
      _ch = -1;
    }  
  }
  
  dynamic _parse_ConstantExpression() {
    var $$;
    _beginToken(4);  
    switch (_ch >= 0 && _ch <= 1114111 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
      case 2:
        var ch0 = _ch, pos0 = _cursor, startPos0 = _startPos;
        _startPos = _cursor;
        while (true) {  
          var ch1 = _ch, pos1 = _cursor, testing0 = _testing; 
          _testing = _inputLen + 1;
          $$ = _parse_Directive();
          _ch = ch1;
          _cursor = pos1; 
          _testing = testing0;
          $$ = null;
          success = !success;
          if (!success) break;
          var seq = new List(3)..[0] = $$;
          $$ = _parse_Spacing();
          if (!success) break;
          seq[1] = $$;
          $$ = _parse_Identifier();
          if (!success) break;
          seq[2] = $$;
          $$ = seq;
          if (success) {    
            final $1 = seq[0];
            final $2 = seq[1];
            final $3 = seq[2];
            $$ = $3;
          }
          break;
        }
        if (!success) {
          _ch = ch0;
          _cursor = pos0;
        }
        _startPos = startPos0;
        break;
      case 1:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect3);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_Directive() {
    var $$;
    _beginToken(12);  
    switch (_ch == 35 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
        var ch0 = _ch, pos0 = _cursor, startPos0 = _startPos;
        _startPos = _cursor;
        while (true) {  
          $$ = '#';
          success = true;
          if (++_cursor < _inputLen) {
            _ch = _input[_cursor];
          } else {
            _ch = -1;
          }
          if (!success) break;
          var seq = new List(2)..[0] = $$;
          switch (_getState(_transitions2)) {
            case 0:
              var startPos1 = _startPos;
              $$ = _matchString(_strings6, 'define');
              _startPos = startPos1;
              break;
            case 1:
              while (true) {
                var startPos2 = _startPos;
                $$ = _matchString(_strings7, 'elif');
                _startPos = startPos2;
                if (success) break;
                var startPos3 = _startPos;
                $$ = _matchString(_strings8, 'else');
                _startPos = startPos3;
                if (success) break;
                var startPos4 = _startPos;
                $$ = _matchString(_strings9, 'endif');
                _startPos = startPos4;
                break;
              }
              break;
            case 2:
              var startPos5 = _startPos;
              $$ = _matchString(_strings10, 'fndef');
              _startPos = startPos5;
              break;
            case 3:
              var startPos6 = _startPos;
              $$ = _matchString(_strings11, 'ifdef');
              _startPos = startPos6;
              break;
            case 4:
              var startPos7 = _startPos;
              $$ = _matchString(_strings12, 'undef');
              _startPos = startPos7;
              break;
            case 5:
            case 6:
              $$ = null;
              success = false;
              break;
          }
          if (!success && _cursor > _testing) {
            _failure(_expect12);
          }
          if (!success) break;
          seq[1] = $$;
          $$ = seq;
          break;
        }
        if (!success) {
          _ch = ch0;
          _cursor = pos0;
        }
        _startPos = startPos0;
        break;
      case 1:
      case 2:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect11);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_ElifLine() {
    var $$;
    _beginToken(3);  
    switch (_ch == 35 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
        var ch0 = _ch, pos0 = _cursor, startPos0 = _startPos;
        _startPos = _cursor;
        while (true) {  
          $$ = _matchString(_strings3, '#elif');
          if (!success) break;
          var seq = new List(2)..[0] = $$;
          $$ = _parse_ConstantExpression();
          if (!success) break;
          seq[1] = $$;
          $$ = seq;
          break;
        }
        if (!success) {
          _ch = ch0;
          _cursor = pos0;
        }
        _startPos = startPos0;
        break;
      case 1:
      case 2:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect2);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_ElifParts() {
    var $$;
    _beginToken(2);  
    switch (_ch == 35 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
        var startPos0 = _startPos;
        var testing0;
        for (var first = true, reps; ;) {  
          switch (_ch == 35 ? 0 : _ch == -1 ? 2 : 1) {  
            case 0:  
              var ch0 = _ch, pos0 = _cursor, startPos1 = _startPos;  
              _startPos = _cursor;  
              while (true) {    
                $$ = _parse_ElifLine();  
                if (!success) break;  
                var seq = new List(2)..[0] = $$;  
                $$ = _parse_Text();  
                if (!success) break;  
                seq[1] = $$;  
                $$ = seq;  
                break;  
              }  
              if (!success) {  
                _ch = ch0;  
                _cursor = pos0;  
              }  
              _startPos = startPos1;  
              break;  
            case 1:  
            case 2:  
              $$ = null;  
              success = false;  
              break;  
          }  
          if (!success && _cursor > _testing) {  
            _failure(_expect2);  
          }  
          if (success) {
           if (first) {      
              first = false;
              reps = [$$];
              testing0 = _testing;                  
            } else {
              reps.add($$);
            }
            _testing = _cursor;   
          } else {
            success = !first;
            if (success) {      
              _testing = testing0;
              $$ = reps;      
            } else $$ = null;
            break;
          }  
        }
        _startPos = startPos0;
        break;
      case 1:
      case 2:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect2);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_ElseLine() {
    var $$;
    _beginToken(9);  
    switch (_ch == 35 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
        var startPos0 = _startPos;
        $$ = _matchString(_strings4, '#else');
        _startPos = startPos0;
        break;
      case 1:
      case 2:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect7);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_ElsePart() {
    var $$;
    _beginToken(8);  
    switch (_ch == 35 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
        var ch0 = _ch, pos0 = _cursor, startPos0 = _startPos;
        _startPos = _cursor;
        while (true) {  
          $$ = _parse_ElseLine();
          if (!success) break;
          var seq = new List(2)..[0] = $$;
          $$ = _parse_Text();
          if (!success) break;
          seq[1] = $$;
          $$ = seq;
          break;
        }
        if (!success) {
          _ch = ch0;
          _cursor = pos0;
        }
        _startPos = startPos0;
        break;
      case 1:
      case 2:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect7);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_EndifLine() {
    var $$;
    _beginToken(10);  
    switch (_ch == 35 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
        var startPos0 = _startPos;
        $$ = _matchString(_strings5, '#endif');
        _startPos = startPos0;
        break;
      case 1:
      case 2:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect8);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_IDENT_CONT() {
    var $$;
    _beginToken(6);  
    switch (_getState(_transitions1)) {
      case 0:
        var startPos0 = _startPos;
        $$ = _matchRange(48, 57);
        _startPos = startPos0;
        break;
      case 1:
        var startPos1 = _startPos;
        $$ = _parse_IDENT_START();
        _startPos = startPos1;
        break;
      case 2:
      case 3:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect5);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_IDENT_START() {
    var $$;
    _beginToken(5);  
    switch (_getState(_transitions0)) {
      case 0:
        var startPos0 = _startPos;
        $$ = _matchMapping(65, 122, _mapping0);
        _startPos = startPos0;
        break;
      case 1:
      case 2:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect4);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_Identifier() {
    var $$;
    _beginToken(7);  
    switch (_getState(_transitions0)) {
      case 0:
        var ch0 = _ch, pos0 = _cursor, startPos0 = _startPos;
        _startPos = _cursor;
        while (true) {  
          $$ = _parse_IDENT_START();
          if (!success) break;
          var seq = new List(3)..[0] = $$;
          var testing0 = _testing; 
          for (var reps = []; ; ) {
            _testing = _cursor;
            $$ = _parse_IDENT_CONT();
            if (success) {  
              reps.add($$);
            } else {
              success = true;
              _testing = testing0;
              $$ = reps;
              break; 
            }
          }
          if (!success) break;
          seq[1] = $$;
          $$ = _parse_Spacing();
          if (!success) break;
          seq[2] = $$;
          $$ = seq;
          if (success) {    
            final $1 = seq[0];
            final $2 = seq[1];
            final $3 = seq[2];
            $$ = _flatten([$1, $2]).join();
          }
          break;
        }
        if (!success) {
          _ch = ch0;
          _cursor = pos0;
        }
        _startPos = startPos0;
        break;
      case 1:
      case 2:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect6);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_IfLine() {
    var $$;
    _beginToken(1);  
    switch (_ch == 35 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
        while (true) {
          var ch0 = _ch, pos0 = _cursor, startPos0 = _startPos;
          _startPos = _cursor;
          while (true) {  
            $$ = _matchString(_strings0, '#if');
            if (!success) break;
            var seq = new List(2)..[0] = $$;
            $$ = _parse_ConstantExpression();
            if (!success) break;
            seq[1] = $$;
            $$ = seq;
            break;
          }
          if (!success) {
            _ch = ch0;
            _cursor = pos0;
          }
          _startPos = startPos0;
          if (success) break;
          var ch1 = _ch, pos1 = _cursor, startPos1 = _startPos;
          _startPos = _cursor;
          while (true) {  
            $$ = _matchString(_strings1, '#ifdef');
            if (!success) break;
            var seq = new List(2)..[0] = $$;
            $$ = _parse_Identifier();
            if (!success) break;
            seq[1] = $$;
            $$ = seq;
            break;
          }
          if (!success) {
            _ch = ch1;
            _cursor = pos1;
          }
          _startPos = startPos1;
          if (success) break;
          var ch2 = _ch, pos2 = _cursor, startPos2 = _startPos;
          _startPos = _cursor;
          while (true) {  
            $$ = _matchString(_strings2, '#ifndef');
            if (!success) break;
            var seq = new List(2)..[0] = $$;
            $$ = _parse_Identifier();
            if (!success) break;
            seq[1] = $$;
            $$ = seq;
            break;
          }
          if (!success) {
            _ch = ch2;
            _cursor = pos2;
          }
          _startPos = startPos2;
          break;
        }
        break;
      case 1:
      case 2:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect1);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_IfPart() {
    var $$;
    _beginToken(0);  
    switch (_ch == 35 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
        var ch0 = _ch, pos0 = _cursor, startPos0 = _startPos;
        _startPos = _cursor;
        while (true) {  
          $$ = _parse_IfLine();
          if (!success) break;
          var seq = new List(2)..[0] = $$;
          $$ = _parse_Text();
          if (!success) break;
          seq[1] = $$;
          $$ = seq;
          break;
        }
        if (!success) {
          _ch = ch0;
          _cursor = pos0;
        }
        _startPos = startPos0;
        break;
      case 1:
      case 2:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect0);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_Spacing() {
    var $$;
    _beginToken(13);  
    switch (_ch >= 0 && _ch <= 1114111 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
      case 2:
        var startPos0 = _startPos;
        var testing0 = _testing; 
        for (var reps = []; ; ) {
          _testing = _cursor;
          $$ = _matchMapping(9, 32, _mapping1);
          if (success) {  
            reps.add($$);
          } else {
            success = true;
            _testing = testing0;
            $$ = reps;
            break; 
          }
        }
        _startPos = startPos0;
        break;
      case 1:
        $$ = null;
        success = true;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect13);
    }
    _endToken();
    return $$;
  }
  
  dynamic _parse_Text() {
    var $$;
    _beginToken(11);  
    switch (_ch >= 0 && _ch <= 1114111 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
      case 2:
        var startPos0 = _startPos;
        var testing0;
        for (var first = true, reps; ;) {  
          switch (_ch >= 0 && _ch <= 1114111 ? 0 : _ch == -1 ? 2 : 1) {  
            case 0:  
            case 2:  
              var ch0 = _ch, pos0 = _cursor, startPos1 = _startPos;  
              _startPos = _cursor;  
              while (true) {    
                var ch1 = _ch, pos1 = _cursor, testing1 = _testing;   
                _testing = _inputLen + 1;  
                $$ = _parse_Directive();  
                _ch = ch1;  
                _cursor = pos1;   
                _testing = testing1;  
                $$ = null;  
                success = !success;  
                if (!success) break;  
                var seq = new List(2)..[0] = $$;  
                $$ = _matchAny();  
                if (!success) break;  
                seq[1] = $$;  
                $$ = seq;  
                break;  
              }  
              if (!success) {  
                _ch = ch0;  
                _cursor = pos0;  
              }  
              _startPos = startPos1;  
              break;  
            case 1:  
              $$ = null;  
              success = false;  
              break;  
          }  
          if (!success && _cursor > _testing) {  
            _failure(_expect10);  
          }  
          if (success) {
           if (first) {      
              first = false;
              reps = [$$];
              testing0 = _testing;                  
            } else {
              reps.add($$);
            }
            _testing = _cursor;   
          } else {
            success = !first;
            if (success) {      
              _testing = testing0;
              $$ = reps;      
            } else $$ = null;
            break;
          }  
        }
        _startPos = startPos0;
        break;
      case 1:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect9);
    }
    _endToken();
    return $$;
  }
  
  String _text() {
    return new String.fromCharCodes(_input.sublist(_startPos, _cursor));
  }
  
  int _toCodePoint(String string) {
    if (string == null) {
      throw new ArgumentError("string: $string");
    }
  
    var length = string.length;
    if (length == 0) {
      throw new StateError("An empty string contains no elements.");
    }
  
    var start = string.codeUnitAt(0);
    if (length == 1) {
      return start;
    }
  
    if ((start & 0xFC00) == 0xD800) {
      var end = string.codeUnitAt(1);
      if ((end & 0xFC00) == 0xDC00) {
        return (0x10000 + ((start & 0x3FF) << 10) + (end & 0x3FF));
      }
    }
  
    return start;
  }
  
  List<int> _toCodePoints(String string) {
    if (string == null) {
      throw new ArgumentError("string: $string");
    }
  
    var length = string.length;
    if (length == 0) {
      return const <int>[];
    }
  
    var codePoints = <int>[];
    codePoints.length = length;
    var i = 0;
    var pos = 0;
    for ( ; i < length; pos++) {
      var start = string.codeUnitAt(i);
      i++;
      if ((start & 0xFC00) == 0xD800 && i < length) {
        var end = string.codeUnitAt(i);
        if ((end & 0xFC00) == 0xDC00) {
          codePoints[pos] = (0x10000 + ((start & 0x3FF) << 10) + (end & 0x3FF));
          i++;
        } else {
          codePoints[pos] = start;
        }
      } else {
        codePoints[pos] = start;
      }
    }
  
    codePoints.length = pos;
    return codePoints;
  }
  
  static List<bool> _unmap(List<int> mapping) {
    var length = mapping.length;
    var result = new List<bool>(length * 31);
    var offset = 0;
    for (var i = 0; i < length; i++) {
      var v = mapping[i];
      for (var j = 0; j < 31; j++) {
        result[offset++] = v & (1 << j) == 0 ? false : true;
      }
    }
    return result;
  }
  
  List<PreprocessorParserError> errors() {
    if (success) {
      return <PreprocessorParserError>[];
    }
  
    String escape(int c) {
      switch (c) {
        case 10:
          return r"\n";
        case 13:
          return r"\r";
        case 09:
          return r"\t";
        case -1:
          return "";
      }
      return new String.fromCharCode(c);
    } 
    
    String getc(int position) {  
      if (position < _inputLen) {
        return "'${escape(_input[position])}'";      
      }       
      return "end of file";
    }
  
    var errors = <PreprocessorParserError>[];
    if (_failurePos >= _cursor) {
      var set = new Set<PreprocessorParserError>();
      set.addAll(_errors);
      for (var error in set) {
        if (error.position >= _failurePos) {
          errors.add(error);
        }
      }
      var names = new Set<String>();  
      names.addAll(_expected);
      if (names.contains(null)) {
        var string = getc(_failurePos);
        var message = "Unexpected $string";
        var error = new PreprocessorParserError(PreprocessorParserError.UNEXPECTED, _failurePos, _failurePos, message);
        errors.add(error);
      } else {      
        var found = getc(_failurePos);      
        var list = names.toList();
        list.sort();
        var message = "Expected ${list.join(", ")} but found $found";
        var error = new PreprocessorParserError(PreprocessorParserError.EXPECTED, _failurePos, _failurePos, message);
        errors.add(error);
      }        
    }
    errors.sort((a, b) => a.position.compareTo(b.position));
    return errors;  
  }
  
  dynamic parse_Conditional() {
    var $$;
    switch (_ch == 35 ? 0 : _ch == -1 ? 2 : 1) {
      case 0:
        var ch0 = _ch, pos0 = _cursor, startPos0 = _startPos;
        _startPos = _cursor;
        while (true) {  
          $$ = _parse_IfPart();
          if (!success) break;
          var seq = new List(4)..[0] = $$;
          var testing0 = _testing;
          _testing = _cursor;
          $$ = _parse_ElifParts();
          success = true; 
          _testing = testing0;
          if (!success) break;
          seq[1] = $$;
          var testing1 = _testing;
          _testing = _cursor;
          $$ = _parse_ElsePart();
          success = true; 
          _testing = testing1;
          if (!success) break;
          seq[2] = $$;
          $$ = _parse_EndifLine();
          if (!success) break;
          seq[3] = $$;
          $$ = seq;
          break;
        }
        if (!success) {
          _ch = ch0;
          _cursor = pos0;
        }
        _startPos = startPos0;
        break;
      case 1:
      case 2:
        $$ = null;
        success = false;
        break;
    }
    if (!success && _cursor > _testing) {
      _failure(_expect0);
    }
    return $$;
  }
  
  void reset(int pos) {
    if (pos == null) {
      throw new ArgumentError('pos: $pos');
    }
    if (pos < 0 || pos > _inputLen) {
      throw new RangeError('pos');
    }      
    _cursor = pos;
    _cache = new List(_inputLen + 1);
    _cachePos = -1;
    _cacheRule = new List(_inputLen + 1);
    _cacheState = new List.filled(((_inputLen + 1) >> 5) + 1, 0);
    _ch = -1;
    _errors = <PreprocessorParserError>[];   
    _expected = <String>[];
    _failurePos = -1;
    _startPos = pos;        
    _testing = -1;
    _token = null;
    _tokenLevel = 0;
    _tokenStart = null;
    if (_cursor < _inputLen) {
      _ch = _input[_cursor];
    }
    success = true;    
  }
  
}

class PreprocessorParserError {
  static const int EXPECTED = 1;    
      
  static const int MALFORMED = 2;    
      
  static const int MISSING = 3;    
      
  static const int UNEXPECTED = 4;    
      
  static const int UNTERMINATED = 5;    
      
  final int hashCode = 0;
  
  final String message;
  
  final int position;
  
  final int start;
  
  final int type;
  
  PreprocessorParserError(this.type, this.position, this.start, this.message);
  
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is PreprocessorParserError) {
      return type == other.type && position == other.position &&
      start == other.start && message == other.message;  
    }
    return false;
  }
  
}

