function ordinal(n) {
  var nHundreds = n % 100;
  var nDecimal = n % 10;

  if ([11, 12, 13].indexOf(nHundreds) > -1) {
    return n + "th"
  }

  if (nDecimal === 1) {
    return n + "st";
  } else if (nDecimal === 2) {
    return n + "nd";
  } else if (nDecimal === 3) {
    return n + "rd";
  }

  return n + "th";
}

function debounce(func, wait, immediate) {
  var timeout;
  return function() {
    var context = this, args = arguments;
    var later = function() {
      timeout = null;
      if (!immediate) func.apply(context, args);
    };
    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  };
};

function clone(obj) {
  return JSON.parse(JSON.stringify(obj));
}

function objectToArray(obj) {
  var arr = [];

  for (var k in obj) {
    if (obj.hasOwnProperty(k)) {
      arr.push(obj[k]);
    }
  }

  return arr;
}
