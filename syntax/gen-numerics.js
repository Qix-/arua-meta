'use strict';

var matchLabel = 'aruaNumber';
var errorLabel = 'aruaNumericError';

function getMatchPattern(i) {
	var pattern = '';

	if (i === 1) {
		pattern = '0';
	} else if (i === 2) {
		pattern = '01';
	} else if (i < 11) {
		pattern = '0-' + (i - 1);
	} else if (i === 11) {
		pattern = '0-9A';
	} else if (i === 12) {
		pattern = '0-9AB';
	} else {
		pattern = '0-9A-' + String.fromCharCode(i - 11 + 'A'.charCodeAt(0));
	}

	return pattern;
}

function generateMatch(i) {
	var pattern = getMatchPattern(i);

	if (pattern.length > 1) {
		pattern = '[' + pattern + ']';
	}

	if (i === 16) {
		i = '(0|16)';
	}

	return 'syn match ' + matchLabel + '\t\t"\\v<' + i + 'x'
		+ pattern + '+>"';
}

function generateError(i) {
	var pattern = getMatchPattern(i);
	var inverse = '';

	if (i === 35)  {
		inverse = 'Z';
	} else if (i === 34) {
		inverse = 'YZ';
	} else if (i === 9) {
		inverse = '9A-Z';
	} else if (i === 8) {
		inverse = '89A-Z';
	} else if (i > 9) {
		inverse = String.fromCharCode('A'.charCodeAt(0) + (i - 10)) + '-Z';
	} else {
		inverse = i + '-9A-Z';
	}

	if (pattern.length > 1) {
		pattern = '[' + pattern + ']';
	}

	if (inverse.length > 1) {
		inverse = '[' + inverse + ']';
	}

	if (i === 16) {
		i = '(0|16)';
	}

	return 'syn match ' + errorLabel + '\t"\\v<' + i + 'x'
		+ '(' + pattern + '*' + '(' + inverse + '+'
		+ pattern + '*)+)>"';
}

for (var i = 1; i <= 36; i++) {
	console.log(generateMatch(i));
	if (i < 36) {
		console.log(generateError(i));
	}
}
