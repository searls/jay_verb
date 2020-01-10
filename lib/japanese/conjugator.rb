module Japanese
  module Conjugator
    # List with complete list of exceptions for
    # consonant verbs that end in -eru -iru at: https://en.wikipedia.org/wiki/Japanese_consonant_and_vowel_verbs#List_of_consonant_stem_verbs_ending_in_iru

    POLITE_VERB_ENDINGS = {present: "ます",
                           past: "ました",
                           present_negative: "ません",
                           past_negative: "ませんでした",
                           volitional: "ましょう",
                           te_form: "まして",}
    NEGATIVE_VERB_ENDINGS = {present: "ない",
                             past: "なかった",
                             te_form: "なくて",}

    CONTINUOUS_ENDINGS = {present_spoken: "る",
                          present_written: "いる",
                          present_polite: "います",
                          present_polite_spoken: "ます",
                          past_spoken: "た",
                          past_written: "いた",
                          past_polite: "いました",
                          past_polite_spoken: "ました",
                          te_form_spoken: "て",
                          te_form_written: "いて",
                          te_form_polite: "いまして",
                          te_form_polite_spoken: "まして",
                          negative_te_form_spoken: "なくて",
                          negative_te_form_written: "いなくて",}

    ROMAJI_POLITE_VERB_ENDINGS = {present: "masu",
                                  past: "mashita",
                                  present_negative: "masen",
                                  past_negative: "masen deshita",
                                  volitional: "masho",
                                  te_form: "mashite",}

    ROMAJI_NEGATIVE_VERB_ENDINGS = {present: "nai",
                                    past: "nakatta",
                                    te_form: "nakute",}

    ROMAJI_CONTINUOUS_ENDINGS = {present_spoken: "ru",
                                 present_written: " iru",
                                 present_polite: " imasu",
                                 present_polite_spoken: "masu",
                                 past_spoken: "ta",
                                 past_written: " ita",
                                 past_polite: " imashita",
                                 past_polite_spoken: "mashita",
                                 te_form_spoken: "te",
                                 te_form_written: " ite",
                                 te_form_polite: " imashite",
                                 te_form_polite_spoken: "mashite",
                                 negative_te_form_spoken: "nakute",
                                 negative_te_form_written: " inakute",}

    VERB_CLASSES = %w[v1 v5b v5g v5k v5k-s v5m v5n v5r v5r-i v5s v5t v5u v5u-s v-aru v-kuru v-suru]

    def process_verb
      if Japanese::Conjugator::VERB_CLASSES.include?(part_of_speech)
        unless ambiguous? # <= Method from JapaneseVerbIdentifier module
          set_verb_stem_form
          set_negative_stem
          set_base
          set_te_form
          set_ta_form
          set_polite_form_conjugations
          set_negative_plain_forms
          set_continuous_forms
          set_prohibitive_form
          set_plain_present_potential
          set_conditional
          set_imperative
          set_volitional
          set_passive_dictionary_form
          set_passive_forms_hash
          set_causative_dictionary_form
          set_causative_forms_hash
          set_causative_passive_dictionary_form
          set_causative_passive_forms_hash
        end
      end
      # self.save => Keep this commented out for now to experiment around in the console.
    end

    # Makes up for the fact that v5u verb endings are represented by one Roman letter as opposed to the
    # verb endings of every other class, which are represented by two Roman letters.
    def romaji_conditional_slice(string)
      if part_of_speech == "v5u" || part_of_speech == "v5u-s"
        string.slice!(-1)
      else
        string.slice!(-2..-1)
      end
    end

    def set_verb_stem_form
      stem = kanji.dup
      hiragana_stem = hiragana.dup
      romaji_stem = romaji.dup
      stem.slice!(-1)
      hiragana_stem.slice!(-1)
      romaji_conditional_slice(romaji_stem)
      # Fill in the logic to figure out what stem ending to add
      case part_of_speech
        when "v1"
          stem
        when "v5b"
          stem += "び"
          hiragana_stem += "び"
          romaji_stem += "bi"
        when "v5k"
          stem += "き"
          hiragana_stem += "き"
          romaji_stem += "ki"
        when "v5k-s"
          stem += "き"
          hiragana_stem += "き"
          romaji_stem += "ki"
        when "v5g"
          stem += "ぎ"
          hiragana_stem += "ぎ"
          romaji_stem += "gi"
        when "v5m"
          stem += "み"
          hiragana_stem += "み"
          romaji_stem += "mi"
        when "v5n"
          stem += "に"
          hiragana_stem += "に"
          romaji_stem += "ni"
        when "v5r"
          stem += "り"
          hiragana_stem += "り"
          romaji_stem += "ri"
        when "v5r-i"
          stem # Assuming this class is for いらっしゃる => いらっしゃ would be the stem
        when "v5s"
          stem += "し"
          hiragana_stem += "し"
          romaji_stem += "shi"
        when "v5t"
          stem += "ち"
          hiragana_stem += "ち"
          romaji_stem += "chi"
        when "v5u"
          stem += "い"
          hiragana_stem += "い"
          romaji_stem += "i"
        when "v5u-s"
          stem += "い" # Assuming this class is for the irregular 問う => 問い would be the stem
          hiragana_stem += "い"
          romaji_stem += "i"
        when "v-kuru"
          stem # Assuming that you enter this in kanji; this will not work in hiragana.
        when "v-suru"
          stem = "し"
          hiragana_stem = "し"
          romaji_stem = "shi"
        when "v-aru"
          stem += "り"
          hiragana_stem += "り"
          romaji_stem += "ri"
      end
      self.stem_form = stem
      hiragana_forms[:stem] = hiragana_stem
      romaji_forms[:stem] = romaji_stem
      # kanji.save! => Comment this out now for experimental purposes
    end

    def set_negative_stem
      stem = kanji.dup
      hiragana_stem = hiragana.dup
      romaji_stem = romaji.dup
      stem.slice!(-1)
      hiragana_stem.slice!(-1)
      romaji_conditional_slice(romaji_stem)
      case part_of_speech
        when "v1"
          stem
        when "v5b"
          stem += "ば"
          hiragana_stem += "ば"
          romaji_stem += "ba"
        when "v5k"
          stem += "か"
          hiragana_stem += "か"
          romaji_stem += "ka"
        when "v5k-s"
          stem += "か"
          hiragana_stem += "か"
          romaji_stem += "ka"
        when "v5g"
          stem += "が"
          hiragana_stem += "が"
          romaji_stem += "ga"
        when "v5m"
          stem += "ま"
          hiragana_stem += "ま"
          romaji_stem += "ma"
        when "v5n"
          stem += "な"
          hiragana_stem += "な"
          romaji_stem += "na"
        when "v5r"
          stem += "ら"
          hiragana_stem += "ら"
          romaji_stem += "ra"
        when "v5r-i"
          stem += "ら" # Assuming this class is for いらっしゃる, いらっしゃら would be the stem
          hiragana_stem += "ら"
          romaji_stem += "ra"
        when "v5s"
          stem += "さ"
          hiragana_stem += "さ"
          romaji_stem += "sa"
        when "v5t"
          stem += "た"
          hiragana_stem += "た"
          romaji_stem += "ta"
        when "v5u"
          stem += "わ"
          hiragana_stem += "わ"
          romaji_stem += "wa"
        when "v5u-s"
          stem += "わ" # Assuming this class is for the irregular 問う, 問い would be the stem
          hiragana_stem += "わ"
          romaji_stem += "wa"
        when "v-kuru"
          hiragana_stem = "こ"
          romaji_stem = "ko"
        when "v-suru"
          stem = "し"
          hiragana_stem = "し"
          romaji_stem = "shi"
        when "v-aru"
          stem = ""
          hiragana_stem = ""
          romaji_stem = ""
      end
      self.negative_stem = stem
      hiragana_forms[:negative_stem] = hiragana_stem
      romaji_forms[:negative_stem] = romaji_stem
    end

    def set_base
      kanji = self.kanji.dup
      hiragana_word = hiragana.dup
      romaji_base = romaji.dup
      kanji.slice!(-1)
      hiragana_word.slice!(-1)
      romaji_conditional_slice(romaji_base)
      self.base = kanji
      hiragana_forms[:base] = hiragana_word
      romaji_forms[:base] = romaji_base
    end

    def set_polite_form_conjugations
      polite = Japanese::Conjugator::POLITE_VERB_ENDINGS.values
      romaji_polite = Japanese::Conjugator::ROMAJI_POLITE_VERB_ENDINGS.values
      stem = stem_form
      hiragana_stem = hiragana_forms[:stem]
      romaji_stem = romaji_forms[:stem]
      conjugations[:polite_forms] = {present: stem + polite[0],
                                     past: stem + polite[1],
                                     present_negative: stem + polite[2],
                                     past_negative: stem + polite[3],
                                     volitional: stem + polite[4],
                                     te_form: stem + polite[5],}
      hiragana_forms[:polite_forms] = {present: hiragana_stem + polite[0],
                                       past: hiragana_stem + polite[1],
                                       present_negative: hiragana_stem + polite[2],
                                       past_negative: hiragana_stem + polite[3],
                                       volitional: hiragana_stem + polite[4],
                                       te_form: hiragana_stem + polite[5],}
      romaji_forms[:polite_forms] = {past: romaji_stem + romaji_polite[1],
                                     present: romaji_stem + romaji_polite[0],
                                     present_negative: romaji_stem + romaji_polite[2],
                                     past_negative: romaji_stem + romaji_polite[3],
                                     volitional: romaji_stem + romaji_polite[4],
                                     te_form: romaji_stem + romaji_polite[5],}
      unless has_volitional
        conjugations[:polite_forms][:volitional] = "N/A"
        hiragana_forms[:polite_forms][:volitional] = "N/A"
        romaji_forms[:polite_forms][:volitional] = "N/A"
      end
    end

    def set_negative_plain_forms
      endings = Japanese::Conjugator::NEGATIVE_VERB_ENDINGS.values
      romaji_endings = Japanese::Conjugator::ROMAJI_NEGATIVE_VERB_ENDINGS.values
      stem = negative_stem
      hiragana_stem = hiragana_forms[:negative_stem]
      romaji_stem = romaji_forms[:negative_stem]
      conjugations[:negative_plain_forms] = {present: stem + endings[0],
                                             past: stem + endings[1],
                                             te_form: stem + endings[2],}
      hiragana_forms[:negative_plain_forms] = {present: hiragana_stem + endings[0],
                                               past: hiragana_stem + endings[1],
                                               te_form: hiragana_stem + endings[2],}
      romaji_forms[:negative_plain_forms] = {present: romaji_stem + romaji_endings[0],
                                             past: romaji_stem + romaji_endings[1],
                                             te_form: romaji_stem + romaji_endings[2],}
    end

    def set_prohibitive_form
      if part_of_speech == "v-aru" || part_of_speech == "v5r-i"
        conjugations[:prohibitive] = "N/A"
        hiragana_forms[:prohibitive] = "N/A"
        romaji_forms[:prohibitive] = "N/A"
      else
        conjugations[:prohibitive] = kanji + "な"
        hiragana_forms[:prohibitive] = hiragana + "な"
        romaji_forms[:prohibitive] = romaji + " na"
      end
    end

    def set_plain_present_potential
      stem = base.dup
      hiragana_stem = hiragana_forms[:base].dup
      romaji_stem = romaji_forms[:base].dup
      case part_of_speech
        when "v1"
          stem += "(ら)れ���"
          hiragana_stem += "(ら)れる"
          romaji_stem += "(ra)reru"
        when "v5b"
          stem += "べる"
          hiragana_stem += "べる"
          romaji_stem += "beru"
        when "v5k"
          stem += "ける"
          hiragana_stem += "ける"
          romaji_stem += "keru"
        when "v5k-s"
          stem += "ける"
          hiragana_stem += "ける"
          romaji_stem += "keru"
        when "v5g"
          stem += "げる"
          hiragana_stem += "げる"
          romaji_stem += "geru"
        when "v5m"
          stem += "める"
          hiragana_stem += "める"
          romaji_stem += "meru"
        when "v5n"
          stem += "ねる"
          hiragana_stem += "ねる"
          romaji_stem += "neru"
        when "v5r"
          stem += "れる"
          hiragana_stem += "れる"
          romaji_stem += "reru"
        when "v5r-i"
          stem = "N/A"
          hiragana_stem = "N/A"
          romaji_stem = "N/A"
        when "v5s"
          stem += "せる"
          hiragana_stem += "せる"
          romaji_stem += "seru"
        when "v5t"
          stem += "てる"
          hiragana_stem += "てる"
          romaji_stem += "teru"
        when "v5u"
          stem += "える"
          hiragana_stem += "える"
          romaji_stem += "eru"
        when "v5u-s"
          stem += "える" # Assuming this class is for the irregular 問う, 問い would be the stem
          hiragana_stem += "える"
          romaji_stem += "eru"
        when "v-kuru"
          stem += "れる" # Assuming that you enter "来る" in kanji; this will not work in hiragana.
          hiragana_stem = "これる"
          romaji_stem = "koreru"
        when "v-suru"
          stem = "できる"
          hiragana_stem = "できる"
          romaji_stem = "dekiru"
        when "v-aru"
          stem = "N/A"
          hiragana_stem = "N/A"
          romaji_stem = "N/A"
      end
      conjugations[:plain_present_potential] = stem
      hiragana_forms[:plain_present_potential] = hiragana_stem
      romaji_forms[:plain_present_potential] = romaji_stem
    end

    def set_conditional
      stem = base.dup
      hiragana_stem = hiragana_forms[:base].dup
      romaji_stem = romaji_forms[:base].dup
      case part_of_speech
        when "v1"
          stem += "れば"
          hiragana_stem += "れば"
          romaji_stem += "reba"
        when "v5b"
          stem += "べば"
          hiragana_stem += "べば"
          romaji_stem += "beba"
        when "v5k"
          stem += "けば"
          hiragana_stem += "けば"
          romaji_stem += "keba"
        when "v5k-s"
          stem += "けば"
          hiragana_stem += "けば"
          romaji_stem += "keba"
        when "v5g"
          stem += "げば"
          hiragana_stem += "げば"
          romaji_stem += "geba"
        when "v5m"
          stem += "めば"
          hiragana_stem += "めば"
          romaji_stem += "meba"
        when "v5n"
          stem += "ねば"
          hiragana_stem += "ねば"
          romaji_stem += "neba"
        when "v5r"
          stem += "れば"
          hiragana_stem += "れば"
          romaji_stem += "reba"
        when "v5r-i"
          stem += "れば" # Assuming this class is for いらっしゃる, いらっしゃら would be the stem
          hiragana_stem += "れば"
          romaji_stem += "reba"
        when "v5s"
          stem += "せば"
          hiragana_stem += "せば"
          romaji_stem += "seba"
        when "v5t"
          stem += "てば"
          hiragana_stem += "てば"
          romaji_stem += "teba"
        when "v5u"
          stem += "えば"
          hiragana_stem += "えば"
          romaji_stem += "eba"
        when "v5u-s"
          stem += "えば" # Assuming this class is for the irregular 問う, 問い would be the stem
          hiragana_stem += "えば"
          romaji_stem += "eba"
        when "v-kuru"
          stem += "れば" # Assuming that you enter "来る" in kanji; this will not work in hiragana.
          hiragana_stem = "これば"
          romaji_stem = "koreba"
        when "v-suru"
          stem += "れば"
          hiragana_stem += "れば"
          romaji_stem += "reba"
        when "v-aru"
          stem += "れば"
          hiragana_stem += "れば"
          romaji_stem += "reba"
      end
      conjugations[:conditional] = stem
      hiragana_forms[:conditional] = hiragana_stem
      romaji_forms[:conditional] = romaji_stem
    end

    def set_te_form
      base = self.base.dup
      hiragana_base = hiragana_forms[:base].dup
      romaji_base = romaji_forms[:base].dup
      case part_of_speech
        when "v1"
          base += "て"
          hiragana_base += "て"
          romaji_base += "te"
        when "v5b"
          base += "んで"
          hiragana_base += "んで"
          romaji_base += "nde"
        when "v5k"
          base += "いて"
          hiragana_base += "いて"
          romaji_base += "ite"
        when "v5k-s"
          base += "って"
          hiragana_base += "って"
          romaji_base += "tte"
        when "v5g"
          base += "いで"
          hiragana_base += "いで"
          romaji_base += "ide"
        when "v5m"
          base += "んで"
          hiragana_base += "んで"
          romaji_base += "nde"
        when "v5n"
          base += "んで"
          hiragana_base += "んで"
          romaji_base += "nde"
        when "v5r"
          base += "って"
          hiragana_base += "って"
          romaji_base += "tte"
        when "v5r-i"
          base += "って" # Assuming this class is for いらっしゃる, いらっしゃって would be the te_form
          hiragana_base += "って"
          romaji_base += "tte"
        when "v5s"
          base += "して"
          hiragana_base += "して"
          romaji_base += "shite"
        when "v5t"
          base += "って"
          hiragana_base += "って"
          romaji_base += "tte"
        when "v5u"
          base += "って"
          hiragana_base += "って"
          romaji_base += "tte"
        when "v5u-s"
          base += "うて" # Assuming this class is for the irregular 問う, 問うて would be the stem
          hiragana_base += "うて"
          romaji_base += "ute"
        when "v-kuru"
          base += "て"
          hiragana_base += "て"
          romaji_base += "te"
        when "v-suru"
          base = "して"
          hiragana_base = "して"
          romaji_base = "shite"
        when "v-aru"
          base += "って"
          hiragana_base += "って"
          romaji_base += "tte"
      end
      conjugations[:te_form] = base
      hiragana_forms[:te_form] = hiragana_base
      romaji_forms[:te_form] = romaji_base
    end

    def set_ta_form
      base = self.base.dup
      hiragana_base = hiragana_forms[:base].dup
      romaji_base = romaji_forms[:base].dup
      case part_of_speech
        when "v1"
          base += "た"
          hiragana_base += "た"
          romaji_base += "ta"
        when "v5b"
          base += "んだ"
          hiragana_base += "んだ"
          romaji_base += "nda"
        when "v5k"
          base += "いた"
          hiragana_base += "いた"
          romaji_base += "ita"
        when "v5k-s"
          base += "った"
          hiragana_base += "った"
          romaji_base += "tta"
        when "v5g"
          base += "いだ"
          hiragana_base += "いだ"
          romaji_base += "ida"
        when "v5m"
          base += "んだ"
          hiragana_base += "んだ"
          romaji_base += "nda"
        when "v5n"
          base += "んだ"
          hiragana_base += "んだ"
          romaji_base += "nda"
        when "v5r"
          base += "った"
          hiragana_base += "った"
          romaji_base += "tta"
        when "v5r-i"
          base += "った" # Assuming this class is for いらっしゃる, いらっしゃった would be the te_form
          hiragana_base += "った"
          romaji_base += "tta"
        when "v5s"
          base += "した"
          hiragana_base += "した"
          romaji_base += "shita"
        when "v5t"
          base += "った"
          hiragana_base += "った"
          romaji_base += "tta"
        when "v5u"
          base += "った"
          hiragana_base += "った"
          romaji_base += "tta"
        when "v5u-s"
          base += "うた" # Assuming this class is for the irregular 問う, 問うた would be the stem
          hiragana_base += "うた"
          romaji_base += "uta"
        when "v-kuru"
          base += "た"
          hiragana_base += "た"
          romaji_base += "ta"
        when "v-suru"
          base = "した"
          hiragana_base = "した"
          romaji_base = "shita"
        when "v-aru"
          base += "った"
          hiragana_base += "った"
          romaji_base += "tta"
      end
      conjugations[:ta_form] = base
      hiragana_forms[:ta_form] = hiragana_base
      romaji_forms[:ta_form] = romaji_base
    end

    def set_imperative
      if has_imperative
        base = self.base.dup
        hiragana_base = hiragana_forms[:base].dup
        romaji_base = romaji_forms[:base].dup
        case part_of_speech
          when "v1"
            base += "ろ"
            hiragana_base += "ろ"
            romaji_base += "ro"
          when "v5b"
            base += "べ"
            hiragana_base += "べ"
            romaji_base += "be"
          when "v5k"
            base += "け"
            hiragana_base += "け"
            romaji_base += "ke"
          when "v5k-s"
            base += "け"
            hiragana_base += "け"
            romaji_base += "ke"
          when "v5g"
            base += "げ"
            hiragana_base += "げ"
            romaji_base += "ge"
          when "v5m"
            base += "め"
            hiragana_base += "め"
            romaji_base += "me"
          when "v5n"
            base += "ね"
            hiragana_base += "ね"
            romaji_base += "ne"
          when "v5r"
            base += "れ"
            hiragana_base += "れ"
            romaji_base += "re"
          when "v5r-i"
            base = "N/A"
            hiragana_base = "N/A"
            romaji_base = "N/A"
          when "v5s"
            base += "せ"
            hiragana_base += "せ"
            romaji_base += "se"
          when "v5t"
            base += "て"
            hiragana_base += "て"
            romaji_base += "te"
          when "v5u"
            base += "え"
            hiragana_base += "え"
            romaji_base += "e"
          when "v5u-s"
            base = "N/A"
            hiragana_base = "N/A"
            romaji_base = "N/A"
          when "v-kuru"
            base += "い"
            hiragana_base = "こい"
            romaji_base = "koi"
          when "v-suru"
            base = "しろ"
            hiragana_base = "しろ"
            romaji_base = "shiro"
          when "v-aru"
            base += "れ"
            hiragana_base += "れ"
            romaji_base += "re"
        end
        conjugations[:imperative] = base
        hiragana_forms[:imperative] = hiragana_base
        romaji_forms[:imperative] = romaji_base
      end
    end

    def set_volitional
      if has_volitional
        base = self.base.dup
        hiragana_base = hiragana_forms[:base].dup
        romaji_base = romaji_forms[:base].dup
        case part_of_speech
          when "v1"
            base += "よう"
            hiragana_base += "よう"
            romaji_base += "yo"
          when "v5b"
            base += "ぼう"
            hiragana_base += "ぼう"
            romaji_base += "bo"
          when "v5k"
            base += "こう"
            hiragana_base += "こう"
            romaji_base += "ko"
          when "v5k-s"
            base += "こう"
            hiragana_base += "こう"
            romaji_base += "ko"
          when "v5g"
            base += "ごう"
            hiragana_base += "ごう"
            romaji_base += "go"
          when "v5m"
            base += "もう"
            hiragana_base += "もう"
            romaji_base += "mo"
          when "v5n"
            base += "のう"
            hiragana_base += "のう"
            romaji_base += "no"
          when "v5r"
            base += "ろう"
            hiragana_base += "ろう"
            romaji_base += "ro"
          when "v5r-i"
            base = "N/A"
            hiragana_base = "N/A"
            romaji_base = "N/A"
          when "v5s"
            base += "そう"
            hiragana_base += "そう"
            romaji_base += "so"
          when "v5t"
            base += "とう"
            hiragana_base += "とう"
            romaji_base += "to"
          when "v5u"
            base += "おう"
            hiragana_base += "おう"
            romaji_base += "o"
          when "v5u-s"
            base = "N/A"
            hiragana_base = "N/A"
            romaji_base = "N/A"
          when "v-kuru"
            base += "よう"
            hiragana_base = "こよう"
            romaji_base = "koyo"
          when "v-suru"
            base = "しよう"
            hiragana_base = "しよう"
            romaji_base = "shiyo"
          when "v-aru"
            base += "ろう"
            hiragana_base += "ろう"
            romaji_base += "ro"
        end
        conjugations[:volitional] = base
        hiragana_forms[:volitional] = hiragana_base
        romaji_forms[:volitional] = romaji_base
      end
    end

    def set_continuous_forms
      endings = Japanese::Conjugator::CONTINUOUS_ENDINGS.values
      romaji_endings = Japanese::Conjugator::ROMAJI_CONTINUOUS_ENDINGS.values
      te_form = conjugations[:te_form]
      hiragana_te_form = hiragana_forms[:te_form]
      romaji_te_form = romaji_forms[:te_form]
      conjugations[:continuous_forms] = {present_spoken: te_form + endings[0],
                                         present_written: te_form + endings[1],
                                         present_polite: te_form + endings[2],
                                         present_polite_spoken: te_form + endings[3],
                                         past_spoken: te_form + endings[4],
                                         past_written: te_form + endings[5],
                                         past_polite: te_form + endings[6],
                                         past_polite_spoken: te_form + endings[7],
                                         te_form_spoken: te_form + endings[8],
                                         te_form_written: te_form + endings[9],
                                         te_form_polite: te_form + endings[10],
                                         te_form_polite_spoken: te_form + endings[11],
                                         negative_te_form_spoken: te_form + endings[12],
                                         negative_te_form_written: te_form + endings[13],}
      hiragana_forms[:continuous_forms] = {present_spoken: hiragana_te_form + endings[0],
                                           present_written: hiragana_te_form + endings[1],
                                           present_polite: hiragana_te_form + endings[2],
                                           present_polite_spoken: hiragana_te_form + endings[3],
                                           past_spoken: hiragana_te_form + endings[4],
                                           past_written: hiragana_te_form + endings[5],
                                           past_polite: hiragana_te_form + endings[6],
                                           past_polite_spoken: hiragana_te_form + endings[7],
                                           te_form_spoken: hiragana_te_form + endings[8],
                                           te_form_written: hiragana_te_form + endings[9],
                                           te_form_polite: hiragana_te_form + endings[10],
                                           te_form_polite_spoken: hiragana_te_form + endings[11],
                                           negative_te_form_spoken: hiragana_te_form + endings[12],
                                           negative_te_form_written: hiragana_te_form + endings[13],}
      romaji_forms[:continuous_forms] = {present_spoken: romaji_te_form + romaji_endings[0],
                                         present_written: romaji_te_form + romaji_endings[1],
                                         present_polite: romaji_te_form + romaji_endings[2],
                                         present_polite_spoken: romaji_te_form + romaji_endings[3],
                                         past_spoken: romaji_te_form + romaji_endings[4],
                                         past_written: romaji_te_form + romaji_endings[5],
                                         past_polite: romaji_te_form + romaji_endings[6],
                                         past_polite_spoken: romaji_te_form + romaji_endings[7],
                                         te_form_spoken: romaji_te_form + romaji_endings[8],
                                         te_form_written: romaji_te_form + romaji_endings[9],
                                         te_form_polite: romaji_te_form + romaji_endings[10],
                                         te_form_polite_spoken: romaji_te_form + romaji_endings[11],
                                         negative_te_form_spoken: romaji_te_form + romaji_endings[12],
                                         negative_te_form_written: romaji_te_form + romaji_endings[13],}
    end

    def process_i_adjective
      set_adjective_base
      set_adjective_adverbial_form
      set_negative_adjective_forms
      set_adjective_conjugations
    end

    def set_adjective_base
      if part_of_speech == "adj-i"
        base = kanji.dup
        base.slice!(-1)
        hiragana_base = hiragana.dup
        hiragana_base.slice!(-1)
        romaji_base = romaji.dup
        romaji_base.slice!(-1)
      end
      conjugations[:adjective_base] = base
      hiragana_forms[:adjective_base] = hiragana_base
      romaji_forms[:adjective_base] = romaji_base
    end

    def set_adjective_adverbial_form
      conjugations[:adverbial_form] = conjugations[:adjective_base] + "く"
      hiragana_forms[:adverbial_form] = hiragana_forms[:adjective_base] + "く"
      romaji_forms[:adverbial_form] = romaji_forms[:adjective_base] + "ku"
    end

    def set_negative_adjective_forms
      neg = conjugations[:adverbial_form]
      hiragana_neg = hiragana_forms[:adverbial_form]
      romaji_neg = romaji_forms[:adverbial_form]
      conjugations[:negative_adjective_forms] = {present: neg + "ない",
                                                 present_polite: neg + "ありません",
                                                 past: neg + "なかった",
                                                 past_polite: neg + "ありませんでした",
                                                 te_form: neg + "なくて",
                                                 present_honorofic: neg + "ございません",
                                                 past_honorific: neg + "ございませんでした",
                                                 te_form_honorific: neg + "ございませんでして",}
      hiragana_forms[:negative_adjective_forms] = {present: hiragana_neg + "ない",
                                                   present_polite: hiragana_neg + "ありません",
                                                   past: hiragana_neg + "なかった",
                                                   past_polite: hiragana_neg + "ありませんでした",
                                                   te_form: hiragana_neg + "なくて",
                                                   present_honorific: hiragana_neg + "ございません",
                                                   past_honorific: hiragana_neg + "ございませんでした",
                                                   te_form_honorific: hiragana_neg + "ございませんでして",}
      romaji_forms[:negative_adjective_forms] = {present: romaji_neg + " nai",
                                                 present_polite: romaji_neg + " arimasen",
                                                 past_polite: romaji_neg + " arimasen deshita",
                                                 past: romaji_neg + " nakatta",
                                                 te_form: romaji_neg + " nakute",
                                                 present_honorific: romaji_neg + " gozaimasen",
                                                 pasts_honorific: romaji_neg + " gozaimasen deshita",
                                                 te_form_honorific: " gozaimasen deshite",}
    end

    def set_adjective_conjugations
      stem = conjugations[:adjective_base]
      hiragana_stem = hiragana_forms[:adjective_base]
      romaji_stem = romaji_forms[:adjective_base]
      conjugations[:adjective_conjugations] = {present: kanji,
                                               present_polite: kanji + "です",
                                               past: stem + "かった",
                                               past_polite: kanji + "でした",
                                               te_form: stem + "くて",}
      hiragana_forms[:adjective_conjugations] = {present: hiragana,
                                                 present_polite: hiragana + "です",
                                                 past: hiragana_stem + "かった",
                                                 past_polite: hiragana + "でした",
                                                 te_form: hiragana_stem + "くて",}
      romaji_forms[:adjective_conjugations] = {present: romaji,
                                               present_polite: romaji + " desu",
                                               past: romaji_stem + "katta",
                                               past_polite: romaji + " deshita",
                                               te_form: romaji_stem + "kute",}
    end

    def set_copula_conjugations
      conjugations[:copula] = {present: "だ",
                               present_polite: "です",
                               present_formal: "である",
                               present_honorific: "でございます",
                               past: "だった",
                               past_polite: "でした",
                               past_formal: "であった",
                               past_honorific: "でございました",
                               volitional: "だろう",
                               volitional_polite: "でしょう",
                               volitional_formal: "であろう",
                               volitional_honorific: "でございましょう",
                               te_form: "で",
                               te_form_polite: "でして",
                               te_form_formal: "であって",
                               te_form_honorific: "でございまして",
                               continuous_formal: "であり",}
      hiragana_forms[:copula] = conjugations[:copula]
      romaji_forms[:copula] = {present: "da",
                               present_polite: "desu",
                               present_formal: "de aru",
                               present_honorific: "de gozaimasu",
                               past: "datta",
                               past_polite: "deshita",
                               past_formal: "de atta",
                               past_honorific: "de gozaimashita",
                               volitional: "daro",
                               volitional_polite: "desho",
                               volitional_formal: "de aro",
                               volitional_honorific: "de gozaimasho",
                               te_form: "de",
                               te_form_polite: "deshite",
                               te_form_formal: "de atte",
                               te_form_honorific: "de gozaimashite",
                               continuous_formal: "de ari",}
    end

    def set_passive_dictionary_form
      if has_passive
        if part_of_speech == "v1"
          stem = stem_form
          hiragana_stem = hiragana_forms[:stem]
          romaji_stem = romaji_forms[:stem]
        elsif part_of_speech == "v-suru"
          stem = "され"
          hiragana_stem = "され"
          romaji_stem = "sare"
        else
          stem = negative_stem
          hiragana_stem = hiragana_forms[:negative_stem]
          romaji_stem = romaji_forms[:negative_stem]
        end
        case part_of_speech
          when "v1"
            passive = stem += "られる"
            hiragana_passive = hiragana_stem += "られる"
            romaji_passive = romaji_stem += "rareru"
          when "v-suru"
            passive = stem += "る"
            hiragana_passive = hiragana_stem += "る"
            romaji_passive = romaji_stem += "ru"
          else
            passive = stem += "れる"
            hiragana_passive = hiragana_stem += "れる"
            romaji_passive = romaji_stem += "reru"
        end
        self.passive_dictionary_form = passive
        hiragana_forms[:passive_dictionary_form] = hiragana_passive
        romaji_forms[:passive_dictionary_form] = romaji_passive
      end
    end

    def set_passive_forms_hash
      if has_passive
        set_passive_stem
        set_passive_polite_forms
        set_passive_negative_plain_forms
        set_passive_te_and_ta_forms
        set_passive_continuous_forms
        set_passive_conditional
      end
    end

    def set_passive_stem
      stem = passive_dictionary_form.dup
      stem.slice!(-1)
      hiragana_stem = hiragana_forms[:passive_dictionary_form].dup
      hiragana_stem.slice!(-1)
      romaji_stem = romaji_forms[:passive_dictionary_form].dup
      romaji_stem.slice!(-2..-1)
      passive_forms[:stem] = stem
      passive_forms_hiragana[:stem] = hiragana_stem
      passive_forms_romaji[:stem] = romaji_stem
    end

    def set_passive_polite_forms
      stem = passive_forms[:stem]
      hiragana_stem = passive_forms_hiragana[:stem]
      romaji_stem = passive_forms_romaji[:stem]
      polite = Japanese::Conjugator::POLITE_VERB_ENDINGS.values
      romaji_polite = Japanese::Conjugator::ROMAJI_POLITE_VERB_ENDINGS.values
      passive_forms[:polite_forms] = {present: stem + polite[0],
                                      past: stem + polite[1],
                                      present_negative: stem + polite[2],
                                      past_negative: stem + polite[3],
                                      te_form: stem + polite[5],}
      passive_forms_hiragana[:polite_forms] = {
        present: hiragana_stem + polite[0],
        past: hiragana_stem + polite[1],
        present_negative: hiragana_stem + polite[2],
        past_negative: hiragana_stem + polite[3],
        te_form: hiragana_stem + polite[5],
      }
      passive_forms_romaji[:polite_forms] = {present: romaji_stem + romaji_polite[0],
                                             past: romaji_stem + romaji_polite[1],
                                             present_negative: romaji_stem + romaji_polite[2],
                                             past_negative: romaji_stem + romaji_polite[3],
                                             te_form: romaji_stem + romaji_polite[5],}
    end

    def set_passive_negative_plain_forms
      stem = passive_forms[:stem]
      hiragana_stem = passive_forms_hiragana[:stem]
      romaji_stem = passive_forms_romaji[:stem]
      endings = Japanese::Conjugator::NEGATIVE_VERB_ENDINGS.values
      romaji_endings = Japanese::Conjugator::ROMAJI_NEGATIVE_VERB_ENDINGS.values
      passive_forms[:negative_plain_forms] = {present: stem + endings[0],
                                              past: stem + endings[1],
                                              te_form: stem + endings[2],}
      passive_forms_hiragana[:negative_plain_forms] = {
        present: hiragana_stem + endings[0],
        past: hiragana_stem + endings[1],
        te_form: hiragana_stem + endings[2],
      }
      passive_forms_romaji[:negative_plain_forms] = {present: romaji_stem + romaji_endings[0],
                                                     past: romaji_stem + romaji_endings[1],
                                                     te_form: romaji_stem + romaji_endings[2],}
    end

    def set_passive_te_and_ta_forms
      stem = passive_forms[:stem]
      hiragana_stem = passive_forms_hiragana[:stem]
      romaji_stem = passive_forms_romaji[:stem]
      passive_forms[:te_form] = stem + "て"
      passive_forms[:ta_form] = stem + "た"
      passive_forms_hiragana[:te_form] = hiragana_stem + "て"
      passive_forms_hiragana[:ta_form] = hiragana_stem + "た"
      passive_forms_romaji[:te_form] = romaji_stem + "te"
      passive_forms_romaji[:ta_form] = romaji_stem + "ta"
    end

    def set_passive_continuous_forms
      te_form = passive_forms[:te_form]
      hiragana_te_form = passive_forms_hiragana[:te_form]
      romaji_te_form = passive_forms_romaji[:te_form]
      endings = Japanese::Conjugator::CONTINUOUS_ENDINGS.values
      romaji_endings = Japanese::Conjugator::ROMAJI_CONTINUOUS_ENDINGS.values
      passive_forms[:continuous_forms] = {present_spoken: te_form + endings[0],
                                          present_written: te_form + endings[1],
                                          present_formal: te_form + endings[2],
                                          present_formal_spoken: te_form + endings[3],
                                          past_spoken: te_form + endings[4],
                                          past_written: te_form + endings[5],
                                          past_formal: te_form + endings[6],
                                          past_polite_spoken: te_form + endings[7],
                                          te_form_spoken: te_form + endings[8],
                                          te_form_written: te_form + endings[9],
                                          te_form_polite: te_form + endings[10],
                                          te_form_polite_spoken: te_form + endings[11],
                                          negative_te_form_spoken: te_form + endings[12],
                                          negative_te_form_written: te_form + endings[13],}
      passive_forms_hiragana[:continuous_forms] = {present_spoken: hiragana_te_form + endings[0],
                                                   present_written: hiragana_te_form + endings[1],
                                                   present_formal: hiragana_te_form + endings[2],
                                                   present_formal_spoken: hiragana_te_form + endings[3],
                                                   past_spoken: hiragana_te_form + endings[4],
                                                   past_written: hiragana_te_form + endings[5],
                                                   past_formal: hiragana_te_form + endings[6],
                                                   past_polite_spoken: hiragana_te_form + endings[7],
                                                   te_form_spoken: hiragana_te_form + endings[8],
                                                   te_form_written: hiragana_te_form + endings[9],
                                                   te_form_polite: hiragana_te_form + endings[10],
                                                   te_form_polite_spoken: hiragana_te_form + endings[11],
                                                   negative_te_form_spoken: hiragana_te_form + endings[12],
                                                   negative_te_form_written: hiragana_te_form + endings[13],}
      passive_forms_romaji[:continuous_forms] = {present_spoken: romaji_te_form + romaji_endings[0],
                                                 present_written: romaji_te_form + romaji_endings[1],
                                                 present_formal: romaji_te_form + romaji_endings[2],
                                                 present_formal_spoken: romaji_te_form + romaji_endings[3],
                                                 past_spoken: romaji_te_form + romaji_endings[4],
                                                 past_written: romaji_te_form + romaji_endings[5],
                                                 past_formal: romaji_te_form + romaji_endings[6],
                                                 past_polite_spoken: romaji_te_form + romaji_endings[7],
                                                 te_form_spoken: romaji_te_form + romaji_endings[8],
                                                 te_form_written: romaji_te_form + romaji_endings[9],
                                                 te_form_polite: romaji_te_form + romaji_endings[10],
                                                 te_form_polite_spoken: romaji_te_form + romaji_endings[11],
                                                 negative_te_form_spoken: romaji_te_form + romaji_endings[12],
                                                 negative_te_form_written: romaji_te_form + romaji_endings[13],}
    end

    def set_passive_conditional
      stem = passive_forms[:stem]
      hiragana_stem = passive_forms_hiragana[:stem]
      romaji_stem = passive_forms_romaji[:stem]
      passive_forms[:conditional] = stem + "ば"
      passive_forms_hiragana[:conditional] = hiragana_stem + "ば"
      passive_forms_romaji[:conditional] = romaji_stem + "ba"
    end

    def set_causative_dictionary_form
      if has_causative
        if part_of_speech == "v1"
          stem = stem_form
          hiragana_stem = hiragana_forms[:stem]
          romaji_stem = romaji_forms[:stem]
        elsif part_of_speech == "v-suru"
          stem = "させ"
          hiragana_stem = "させ"
          romaji_stem = "sase"
        else
          stem = negative_stem
          hiragana_stem = hiragana_forms[:negative_stem]
          romaji_stem = romaji_forms[:negative_stem]
        end
        case part_of_speech
          when "v1"
            causative = stem += "させる"
            hiragana_causative = hiragana_stem += "させる"
            romaji_causative = romaji_stem += "saseru"
          when "v-suru"
            causative = stem += "る"
            hiragana_causative = hiragana_stem += "る"
            romaji_causative = romaji_stem += "ru"
          else
            causative = stem += "せる"
            hiragana_causative = hiragana_stem += "せる"
            romaji_causative = romaji_stem += "seru"
        end
        self.causative_dictionary_form = causative
        hiragana_forms[:causative_dictionary_form] = hiragana_causative
        romaji_forms[:causative_dictionary_form] = romaji_causative
      end
    end

    def set_causative_stem
      stem = causative_dictionary_form.dup
      stem.slice!(-1)
      hiragana_stem = hiragana_forms[:causative_dictionary_form].dup
      hiragana_stem.slice!(-1)
      romaji_stem = romaji_forms[:causative_dictionary_form].dup
      romaji_stem.slice!(-2..-1)
      causative_forms[:stem] = stem
      causative_forms_hiragana[:stem] = hiragana_stem
      causative_forms_romaji[:stem] = romaji_stem
    end

    def set_causative_forms_hash
      if has_causative
        set_causative_stem
        set_causative_te_and_ta_forms
        set_causative_polite_forms
        set_causative_negative_plain_forms
        set_causative_continuous_forms
        set_causative_prohibitive_form
        set_causative_conditional
        set_causative_imperative
        set_causative_volitional
      end
    end

    def set_causative_te_and_ta_forms
      stem = causative_forms[:stem]
      hiragana_stem = causative_forms_hiragana[:stem]
      romaji_stem = causative_forms_romaji[:stem]
      causative_forms[:te_form] = stem + "て"
      causative_forms[:ta_form] = stem + "た"
      causative_forms_hiragana[:te_form] = hiragana_stem + "て"
      causative_forms_hiragana[:ta_form] = hiragana_stem + "た"
      causative_forms_romaji[:te_form] = romaji_stem + "te"
      causative_forms_romaji[:ta_form] = romaji_stem + "ta"
    end

    def set_causative_polite_forms
      polite = Japanese::Conjugator::POLITE_VERB_ENDINGS.values
      romaji_polite = Japanese::Conjugator::ROMAJI_POLITE_VERB_ENDINGS.values
      stem = causative_forms[:stem]
      hiragana_stem = causative_forms_hiragana[:stem]
      romaji_stem = causative_forms_romaji[:stem]
      causative_forms[:polite_forms] = {present: stem + polite[0],
                                        past: stem + polite[1],
                                        present_negative: stem + polite[2],
                                        past_negative: stem + polite[3],
                                        volitional: stem + polite[4],
                                        te_form: stem + polite[5],}

      causative_forms_hiragana[:polite_forms] = {present: hiragana_stem + polite[0],
                                                 past: hiragana_stem + polite[1],
                                                 present_negative: hiragana_stem + polite[2],
                                                 past_negative: hiragana_stem + polite[3],
                                                 volitional: hiragana_stem + polite[4],
                                                 te_form: hiragana_stem + polite[5],}
      causative_forms_romaji[:polite_forms] = {present: romaji_stem + romaji_polite[0],
                                               past: romaji_stem + romaji_polite[1],
                                               present_negative: romaji_stem + romaji_polite[2],
                                               past_negative: romaji_stem + romaji_polite[3],
                                               volitional: romaji_stem + romaji_polite[4],
                                               te_form: romaji_stem + romaji_polite[5],}
    end

    def set_causative_negative_plain_forms
      endings = Japanese::Conjugator::NEGATIVE_VERB_ENDINGS.values
      romaji_endings = Japanese::Conjugator::ROMAJI_NEGATIVE_VERB_ENDINGS.values
      stem = causative_forms[:stem]
      hiragana_stem = causative_forms_hiragana[:stem]
      romaji_stem = causative_forms_romaji[:stem]
      causative_forms[:negative_plain_forms] = {present: stem + endings[0],
                                                past: stem + endings[1],
                                                te_form: stem + endings[2],}

      causative_forms_hiragana[:negative_plain_forms] = {present: hiragana_stem + endings[0],
                                                         past: hiragana_stem + endings[1],
                                                         te_form: hiragana_stem + endings[2],}
      causative_forms_romaji[:negative_plain_forms] = {present: romaji_stem + romaji_endings[0],
                                                       past: romaji_stem + romaji_endings[1],
                                                       te_form: romaji_stem + romaji_endings[2],}
    end

    def set_causative_continuous_forms
      endings = Japanese::Conjugator::CONTINUOUS_ENDINGS.values
      romaji_endings = Japanese::Conjugator::ROMAJI_CONTINUOUS_ENDINGS.values
      te_form = causative_forms[:te_form]
      hiragana_te_form = causative_forms_hiragana[:te_form]
      romaji_te_form = causative_forms_romaji[:te_form]
      causative_forms[:continuous_forms] = {present_spoken: te_form + endings[0],
                                            present_written: te_form + endings[1],
                                            present_formal: te_form + endings[2],
                                            present_formal_spoken: te_form + endings[3],
                                            past_spoken: te_form + endings[4],
                                            past_written: te_form + endings[5],
                                            past_formal: te_form + endings[6],
                                            past_polite_spoken: te_form + endings[7],
                                            te_form_spoken: te_form + endings[8],
                                            te_form_written: te_form + endings[9],
                                            te_form_polite: te_form + endings[10],
                                            te_form_polite_spoken: te_form + endings[11],
                                            negative_te_form_spoken: te_form + endings[12],
                                            negative_te_form_written: te_form + endings[13],}

      causative_forms_hiragana[:continuous_forms] = {present_spoken: hiragana_te_form + endings[0],
                                                     present_written: hiragana_te_form + endings[1],
                                                     present_formal: hiragana_te_form + endings[2],
                                                     present_formal_spoken: hiragana_te_form + endings[3],
                                                     past_spoken: hiragana_te_form + endings[4],
                                                     past_written: hiragana_te_form + endings[5],
                                                     past_formal: hiragana_te_form + endings[6],
                                                     past_polite_spoken: hiragana_te_form + endings[7],
                                                     te_form_spoken: hiragana_te_form + endings[8],
                                                     te_form_written: hiragana_te_form + endings[9],
                                                     te_form_polite: hiragana_te_form + endings[10],
                                                     te_form_polite_spoken: hiragana_te_form + endings[11],
                                                     negative_te_form_spoken: hiragana_te_form + endings[12],
                                                     negative_te_form_written: hiragana_te_form + endings[13],}
      causative_forms_romaji[:continuous_forms] = {present_spoken: romaji_te_form + romaji_endings[0],
                                                   present_written: romaji_te_form + romaji_endings[1],
                                                   present_formal: romaji_te_form + romaji_endings[2],
                                                   present_formal_spoken: romaji_te_form + romaji_endings[3],
                                                   past_spoken: romaji_te_form + romaji_endings[4],
                                                   past_written: romaji_te_form + romaji_endings[5],
                                                   past_formal: romaji_te_form + romaji_endings[6],
                                                   past_polite_spoken: romaji_te_form + romaji_endings[7],
                                                   te_form_spoken: romaji_te_form + romaji_endings[8],
                                                   te_form_written: romaji_te_form + romaji_endings[9],
                                                   te_form_polite: romaji_te_form + romaji_endings[10],
                                                   te_form_polite_spoken: romaji_te_form + romaji_endings[11],
                                                   negative_te_form_spoken: romaji_te_form + romaji_endings[12],
                                                   negative_te_form_written: romaji_te_form + romaji_endings[13],}
    end

    def set_causative_prohibitive_form
      causative_forms[:prohibitive] = causative_dictionary_form + "な"
      causative_forms_hiragana[:prohibitive] = hiragana_forms[:causative_dictionary_form] + "な"
      causative_forms_romaji[:prohibitive] = romaji_forms[:causative_dictionary_form] + " na"
    end

    def set_causative_conditional
      causative_forms[:conditional] = causative_forms[:stem] + "ば"
      causative_forms_hiragana[:conditional] = causative_forms_hiragana[:stem] + "ば"
      causative_forms_romaji[:conditional] = causative_forms_romaji[:stem] + "ba"
    end

    def set_causative_imperative
      causative_forms[:imperative] = causative_forms[:stem] + "ろ"
      causative_forms_hiragana[:imperative] = causative_forms_hiragana[:stem] + "ろ"
      causative_forms_romaji[:imperative] = causative_forms_romaji[:stem] + "ro"
    end

    def set_causative_volitional
      causative_forms[:volitional] = causative_forms[:stem] + "よう"
      causative_forms_hiragana[:volitional] = causative_forms_hiragana[:stem] + "よう"
      causative_forms_romaji[:volitional] = causative_forms_romaji[:stem] + "yo"
    end

    def set_causative_passive_dictionary_form
      if has_causative_passive
        if part_of_speech.in?(%w[v5k v5k-s v5b v5g v5m v5n v5r v5s v5t v5u v5u-s])
          if part_of_speech == "v5s" # This chunk handles v5s class verbs
            stem = negative_stem
            hiragana_stem = hiragana_forms[:negative_stem]
            romaji_stem = romaji_forms[:negative_stem]
            self.causative_passive_dictionary_form = stem + "れる"
            hiragana_forms[:causative_passive_dictionary_form] = hiragana_stem + "れる"
            romaji_forms[:causative_passive_dictionary_form] = romaji_stem + "reru"
          else # This handles all consonant regular verbs except v5s class verbs
            stem = negative_stem
            hiragana_stem = hiragana_forms[:negative_stem]
            romaji_stem = romaji_forms[:negative_stem]
            self.causative_passive_dictionary_form = stem + "される"
            hiragana_forms[:causative_passive_dictionary_form] = hiragana_stem + "される"
            romaji_forms[:causative_passive_dictionary_form] = romaji_stem + "sareru"
          end
        else # Because only vowel verbs will conjugate properly from the causative stem
          stem = causative_forms[:stem]
          hiragana_stem = causative_forms_hiragana[:stem]
          romaji_stem = causative_forms_romaji[:stem]
          self.causative_passive_dictionary_form = stem + "られる"
          hiragana_forms[:causative_passive_dictionary_form] = hiragana_stem + "られる"
          romaji_forms[:causative_passive_dictionary_form] = romaji_stem + "rareru"
        end
      end
    end

    def set_causative_passive_stem
      stem = causative_passive_dictionary_form.dup
      stem.slice!(-1)
      hiragana_stem = hiragana_forms[:causative_passive_dictionary_form].dup
      hiragana_stem.slice!(-1)
      romaji_stem = romaji_forms[:causative_passive_dictionary_form].dup
      romaji_stem.slice!(-2..-1)
      causative_passive_forms[:stem] = stem
      causative_passive_forms_hiragana[:stem] = hiragana_stem
      causative_passive_forms_romaji[:stem] = romaji_stem
    end

    def set_causative_passive_forms_hash
      if has_causative_passive
        set_causative_passive_stem
        set_causative_passive_te_and_ta_forms
        set_causative_passive_polite_forms
        set_causative_passive_negative_plain_forms
        set_causative_passive_continuous_forms
        set_causative_passive_conditional
      end
    end

    def set_causative_passive_polite_forms
      stem = causative_passive_forms[:stem]
      hiragana_stem = causative_passive_forms_hiragana[:stem]
      romaji_stem = causative_passive_forms_romaji[:stem]
      romaji_polite = Japanese::Conjugator::ROMAJI_POLITE_VERB_ENDINGS.values
      polite = Japanese::Conjugator::POLITE_VERB_ENDINGS.values
      causative_passive_forms[:polite_forms] = {present: stem + polite[0],
                                                past: stem + polite[1],
                                                present_negative: stem + polite[2],
                                                past_negative: stem + polite[3],
                                                te_form: stem + polite[5],}

      causative_passive_forms_hiragana[:polite_forms] = {present: hiragana_stem + polite[0],
                                                         past: hiragana_stem + polite[1],
                                                         present_negative: hiragana_stem + polite[2],
                                                         past_negative: hiragana_stem + polite[3],
                                                         te_form: hiragana_stem + polite[5],}
      causative_passive_forms_romaji[:polite_forms] = {present: romaji_stem + romaji_polite[0],
                                                       past: romaji_stem + romaji_polite[1],
                                                       present_negative: romaji_stem + romaji_polite[2],
                                                       past_negative: romaji_stem + romaji_polite[3],
                                                       te_form: romaji_stem + romaji_polite[5],}
    end

    def set_causative_passive_negative_plain_forms
      stem = causative_passive_forms[:stem]
      hiragana_stem = causative_passive_forms_hiragana[:stem]
      romaji_stem = causative_passive_forms_romaji[:stem]
      endings = Japanese::Conjugator::NEGATIVE_VERB_ENDINGS.values
      romaji_endings = Japanese::Conjugator::ROMAJI_NEGATIVE_VERB_ENDINGS.values
      causative_passive_forms[:negative_plain_forms] = {present: stem + endings[0],
                                                        past: stem + endings[1],
                                                        te_form: stem + endings[2],}

      causative_passive_forms_hiragana[:negative_plain_forms] = {present: hiragana_stem + endings[0],
                                                                 past: hiragana_stem + endings[1],
                                                                 te_form: hiragana_stem + endings[2],}
      causative_passive_forms_romaji[:negative_plain_forms] = {present: romaji_stem + romaji_endings[0],
                                                               past: romaji_stem + romaji_endings[1],
                                                               te_form: romaji_stem + romaji_endings[2],}
    end

    def set_causative_passive_te_and_ta_forms
      stem = causative_passive_forms[:stem]
      hiragana_stem = causative_passive_forms_hiragana[:stem]
      romaji_stem = causative_passive_forms_romaji[:stem]
      causative_passive_forms[:te_form] = stem + "て"
      causative_passive_forms[:ta_form] = stem + "た"
      causative_passive_forms_hiragana[:te_form] = hiragana_stem + "て"
      causative_passive_forms_hiragana[:ta_form] = hiragana_stem + "た"
      causative_passive_forms_romaji[:te_form] = romaji_stem + "te"
      causative_passive_forms_romaji[:ta_form] = romaji_stem + "ta"
    end

    def set_causative_passive_continuous_forms
      te_form = causative_passive_forms[:te_form]
      hiragana_te_form = causative_passive_forms_hiragana[:te_form]
      romaji_te_form = causative_passive_forms_romaji[:te_form]
      endings = Japanese::Conjugator::CONTINUOUS_ENDINGS.values
      romaji_endings = Japanese::Conjugator::ROMAJI_CONTINUOUS_ENDINGS.values
      causative_passive_forms[:continuous_forms] = {present_spoken: te_form + endings[0],
                                                    present_written: te_form + endings[1],
                                                    present_formal: te_form + endings[2],
                                                    present_formal_spoken: te_form + endings[3],
                                                    past_spoken: te_form + endings[4],
                                                    past_written: te_form + endings[5],
                                                    past_formal: te_form + endings[6],
                                                    past_polite_spoken: te_form + endings[7],
                                                    te_form_spoken: te_form + endings[8],
                                                    te_form_written: te_form + endings[9],
                                                    te_form_polite: te_form + endings[10],
                                                    te_form_polite_spoken: te_form + endings[11],
                                                    negative_te_form_spoken: te_form + endings[12],
                                                    negative_te_form_written: te_form + endings[13],}

      causative_passive_forms_hiragana[:continuous_forms] = {present_spoken: hiragana_te_form + endings[0],
                                                             present_written: hiragana_te_form + endings[1],
                                                             present_formal: hiragana_te_form + endings[2],
                                                             present_formal_spoken: hiragana_te_form + endings[3],
                                                             past_spoken: hiragana_te_form + endings[4],
                                                             past_written: hiragana_te_form + endings[5],
                                                             past_formal: hiragana_te_form + endings[6],
                                                             past_polite_spoken: hiragana_te_form + endings[7],
                                                             te_form_spoken: hiragana_te_form + endings[8],
                                                             te_form_written: hiragana_te_form + endings[9],
                                                             te_form_polite: hiragana_te_form + endings[10],
                                                             te_form_polite_spoken: hiragana_te_form + endings[11],
                                                             negative_te_form_spoken: hiragana_te_form + endings[12],
                                                             negative_te_form_written: hiragana_te_form + endings[13],}
      causative_passive_forms_romaji[:continuous_forms] = {present_spoken: romaji_te_form + romaji_endings[0],
                                                           present_written: romaji_te_form + romaji_endings[1],
                                                           present_formal: romaji_te_form + romaji_endings[2],
                                                           present_formal_spoken: romaji_te_form + romaji_endings[3],
                                                           past_spoken: romaji_te_form + romaji_endings[4],
                                                           past_written: romaji_te_form + romaji_endings[5],
                                                           past_formal: romaji_te_form + romaji_endings[6],
                                                           past_polite_spoken: romaji_te_form + romaji_endings[7],
                                                           te_form_spoken: romaji_te_form + romaji_endings[8],
                                                           te_form_written: romaji_te_form + romaji_endings[9],
                                                           te_form_polite: romaji_te_form + romaji_endings[10],
                                                           te_form_polite_spoken: romaji_te_form + romaji_endings[11],
                                                           negative_te_form_spoken: romaji_te_form + romaji_endings[12],
                                                           negative_te_form_written: romaji_te_form + romaji_endings[13],}
    end

    def set_causative_passive_conditional
      stem = causative_passive_forms[:stem]
      hiragana_stem = causative_passive_forms_hiragana[:stem]
      romaji_stem = causative_passive_forms_romaji[:stem]
      causative_passive_forms[:conditional] = stem + "ば"
      causative_passive_forms_hiragana[:conditional] = hiragana_stem + "ば"
      causative_passive_forms_romaji[:conditional] = romaji_stem + "ba"
    end
  end
end
