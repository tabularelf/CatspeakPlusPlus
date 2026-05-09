var _add = function() {
	var _result = argument[0];
	var _i = 1;
	repeat(argument_count-1) {
		_result += argument[_i++];
	}

	return _result;
};

Catspeak.interface.exposeCompileTimeFunction("add", _add);
Catspeak.interface.exposeFunction("add2", _add);
Catspeak.interface.exposeFunction("is_undefined", is_undefined);

var _codeMethodTest = @'
callback = fun(a, b, c) {
	return a + b + c;
}

let num = 2;

resultA = callback(1, 2, 3);
resultB = callback(1, num, 3);

result = {
		a: resultA,
		b: resultB,
};
';

var _addCompileTimeTest = $"result = add({string_repeat("1,", 3999)}1);";
var _addConstantSomeAwareTest = $"result = add({string_repeat("1,", 3999)}num);";
var _addBase = $"result = add({string_repeat("num,", 3999)}num);";
var _addConstantAwareTest = $"result = add2({string_repeat("1,", 3999)}1);";

runTest = function(_string, _name) {
	var _t = get_timer();
	var _ast = Catspeak.parseString(_string);
	show_debug_message($"{_name} parse time: {(get_timer() - _t) / 1000}ms");
	var _t = get_timer();
	var _program = Catspeak.compile(_ast);
	show_debug_message($"{_name} compile time: {(get_timer() - _t) / 1000}ms");
	var _globals = _program.getGlobals();
	_globals.num = 1;
	var _t = get_timer();
	_program();
	show_debug_message($"{_name} execute time: {(get_timer() - _t) / 1000}ms");
	return _globals.result;
}

var _t = get_timer();
var _result = runTest(_addBase, "Add base test");
show_debug_message($"Total time: {(get_timer() - _t) / 1000}ms\nResults: {_result}");

var _t = get_timer();
var _result = runTest(_addConstantSomeAwareTest, "Add Constant Some Aware test");
show_debug_message($"Total time: {(get_timer() - _t) / 1000}ms\nResults: {_result}");

var _t = get_timer();
var _result = runTest(_addConstantAwareTest, "Add Constant Aware test");
show_debug_message($"Total time: {(get_timer() - _t) / 1000}ms\nResults: {_result}");

var _t = get_timer();
var _result = runTest(_addCompileTimeTest, "Add Compile Time Test");
show_debug_message($"Total time: {(get_timer() - _t) / 1000}ms\nResults: {_result}");

var _t = get_timer();
var _result = runTest(_codeMethodTest, "Method constant test");
show_debug_message($"Total time: {(get_timer() - _t) / 1000}ms\nResults: {_result}");