String parseJson(String json) {
  return json.replaceAll("\"[", "[")
      .replaceAll("]\"", "]")
      .replaceAll("\\""\"", "\"")
      .replaceAll("\"{", "{")
      .replaceAll("}\"", "}");
}