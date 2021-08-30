String capitalize(String value) =>
    '${value[0].toUpperCase()}${value.substring(1)}';

String capitalizeFirstLeetOfEachWord(String value) => !value.isNotEmpty
    ? ''
    : value.toLowerCase().split(' ').map((word) {
        final leftWord =
            (word.length > 1) ? word.substring(1, word.length) : '';
        return word[0].toUpperCase() + leftWord;
      }).join(' ');
