/**
 * Mapper interface, used to map one object to another
 */
mixin Mapper<FROM, TO> {
  TO mapTo(FROM from);
}
