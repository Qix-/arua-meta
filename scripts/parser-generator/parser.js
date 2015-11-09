'use strict';

var pegjs = require('pegjs');
var fs = require('fs');
var path = require('path');
var errorEx = require('error-ex');

var parserGrammar = path.join(__dirname, 'generator.pegjs');
var aruaGrammar = path.normalize(path.join(__dirname, '../../arua.grammar'));

var filenameError = {
	sourceException: {
		line: function (e) {
			return 'in ' + e[1] + ':' + e[0].location.start.line + ':' +
				e[0].location.start.column;
		},

		message: function (e, message) {
			var newLines = [];

			var sourceLines = e[2].split(/\r?\n/g);

			var startLine = e[0].location.start.line;
			var endLine = e[0].location.end.line;

			var lines = sourceLines.slice(startLine - 1, endLine);
			var start = e[0].location.start.column;
			var end = e[0].location.end.column;

			// Adjust for tabs.
			var begin = lines[0].length;
			var last = lines[lines.length - 1].length;
			lines = lines.map(function (l) {
				return l.replace(/\t/g, '    ');
			});
			start += lines[0].length - begin;
			end += lines[lines.length - 1].length - last;

			newLines = newLines.concat(['']).concat(lines);

			if (lines.length === 1) {
				var pointer = new Array(start).join(' ');
				pointer += new Array(end - start + 1).join('^');
				newLines.push(pointer);
				newLines.push('');
			}

			newLines = newLines.map(function (l) {
				return '\t' + l;
			});
			return message.concat(newLines);
		}
	}
};

var parser = fs.readFileSync(parserGrammar).toString();
try {
	parser = pegjs.buildParser(parser, {trace: true});
} catch (e) {
	var ParserBuildError = errorEx('ParserBuildError', filenameError);
	var ex = new ParserBuildError(e.message)
	ex.sourceException = [e, parserGrammar, parser];
	throw ex;
}

var result = fs.readFileSync(aruaGrammar).toString();
try {
	result = parser.parse(result);
} catch (e) {
	var ParserError = errorEx('ParserError', filenameError);
	var ex = new ParserError(e.message)
	ex.sourceException = [e, aruaGrammar, result];
	throw ex;
}

console.log(result);
