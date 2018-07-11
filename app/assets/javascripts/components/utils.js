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
