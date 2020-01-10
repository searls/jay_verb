require "test_helper"

class ConjugatorTest < Minitest::Test
  def test_sagasu
    result = Conjugator("探す", "さがす")

    assert_conjugation("探す", {
      present: {
        polite: "探します",
        plain: "探す",
      },
      negative: {
        polite: "探しません",
        plain: "探さない",
      },
      past: {
        polite: "探しました",
        plain: "探した",
      },
      negative_past: {
        polite: "探しませんでした",
        plain: "探さなかった",
      },
      volitional: {
        polite: "探しましょう",
        plain: "探そう",
      },
      te: "探して",
      imperative: "探せ",
      passive: "探される",
      causative: "探させる",
      hypothetical: "探せば",
      potential: "探せる",
    }, result)
  end

  def test_suru
    result = Conjugator("する", "する")

    assert_conjugation("する", {
      present: {
        polite: "します",
        plain: "する",
      },
      negative: {
        polite: "しません",
        plain: "しない",
      },
      past: {
        polite: "しました",
        plain: "した",
      },
      negative_past: {
        polite: "しませんでした",
        plain: "しなかった",
      },
      volitional: {
        polite: "しましょう",
        plain: "しよう",
      },
      te: "して",
      imperative: "しろ",
      passive: "される",
      causative: "させる",
      hypothetical: "すれば",
      potential: "できる",
    }, result)
  end

  private

  def assert_conjugation(plain, expected, result)
    assert_equal({
      present: {
        polite: result.conjugations.dig(:polite_forms, :present),
        plain: plain,
      },
      negative: {
        polite: result.conjugations.dig(:polite_forms, :present_negative),
        plain: result.conjugations.dig(:negative_plain_forms, :present),
      },
      past: {
        polite: result.conjugations.dig(:polite_forms, :past),
        plain: result.conjugations[:ta_form],
      },
      negative_past: {
        polite: result.conjugations.dig(:polite_forms, :past_negative),
        plain: result.conjugations.dig(:negative_plain_forms, :past),
      },
      volitional: {
        polite: result.conjugations.dig(:polite_forms, :volitional),
        plain: result.conjugations[:volitional],
      },
      te: result.conjugations[:te_form],
      imperative: result.conjugations[:imperative],
      passive: result.passive_dictionary_form,
      causative: result.causative_dictionary_form,
      hypothetical: result.conjugations[:conditional],
      potential: result.conjugations[:plain_present_potential],
    }, expected)
  end
end
