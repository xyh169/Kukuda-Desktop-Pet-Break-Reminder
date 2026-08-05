import Foundation

struct ReminderMessage: Equatable {
    let maori: String
    let english: String
}

enum ReminderMessages {
    static let rest: [ReminderMessage] = [
        .init(
            maori: "Kua tae te wā ki te whakatā!",
            english: "Time for a break!"
        ),
        .init(
            maori: "Me whakatā hoki i waenga i ngā pakanga.",
            english: "Even fighting needs a rest."
        ),
        .init(
            maori: "Me whakatā hoki i te wā e kimi kai ana.",
            english: "Foraging needs breaks too."
        ),
        .init(
            maori: "He rangi kikorangi, he kapua mā — me hīkoi tāua!",
            english: "Blue skies and white clouds — let’s take a walk!"
        ),
        .init(
            maori: "Ka rawe kē te hararei whaiutu!",
            english: "Paid leave is the best kind of fun!"
        ),
        .init(
            maori: "Tiakina ō karu, kia kaha tonu ai koe ki te kimi kai.",
            english: "Protect your eyes, so you can keep foraging."
        ),
        .init(
            maori: "Titiro ki tawhiti, kātahi ka kimokimo pōturi.",
            english: "Look far away, then blink slowly."
        ),
        .init(
            maori: "Whātoro ō parirau, whakangā hoki ō pakihiwi.",
            english: "Stretch your wings and relax your shoulders."
        ),
        .init(
            maori: "Inumia he wai. Ka mihi tō tinana ki a koe.",
            english: "Drink some water. Your body will thank you."
        ),
        .init(
            maori: "He mahi anō ā muri ake. Me whakatā ināianei.",
            english: "The work will still be here. Rest now."
        )
    ]

    static let play: [ReminderMessage] = [
        .init(maori: "Kia kanikani tāua!", english: "Let’s dance!"),
        .init(maori: "He kiwi kakama ahau!", english: "I’m a speedy kiwi!"),
        .init(maori: "Ko Kukuda tēnei — tākaro mai!", english: "Kukuda here — come play with me!"),
        .init(maori: "Ka pai! Kua menemene koe.", english: "Nice! You’re smiling now."),
        .init(maori: "Kanikani tuatahi, mahi ā muri ake!", english: "Dance first, work later!"),
        .init(maori: "Kāore aku parirau e aukati i ahau!", english: "Tiny wings can’t stop me!"),
        .init(maori: "He wā tākaro tēnei — he whakahau nā te kiwi!", english: "Playtime — kiwi’s orders!"),
        .init(maori: "Kua piki ake te wairua!", english: "Morale successfully upgraded!")
    ]

    static let sprint: [ReminderMessage] = [
        .init(maori: "Hopu mai mēnā ka taea!", english: "Catch me if you can!"),
        .init(maori: "Kua whakakāngia te tere kiwi!", english: "Kiwi turbo activated!"),
        .init(maori: "He waewae kaha, he kiwi tere!", english: "Powerful legs, speedy kiwi!"),
        .init(maori: "Ka oma tika au ki te wā whakatā!", english: "Sprinting straight into break time!")
    ]

    static let spin: [ReminderMessage] = [
        .init(maori: "Hurihuri! Kei hea a runga?", english: "Spin, spin — which way is up?"),
        .init(maori: "He āwhiowhio kiwi ahau!", english: "I’m a kiwi whirlwind!"),
        .init(maori: "Kotahi anō te huri!", english: "One more twirl!"),
        .init(maori: "Kua pōturi te mahi, kua tere te kiwi!", english: "Work slowed down. Kiwi sped up!")
    ]

    static let jump: [ReminderMessage] = [
        .init(maori: "He parirau iti, he wawata nui!", english: "Tiny wings, big ambitions!"),
        .init(maori: "Titiro! Kua tata au ki te rere!", english: "Look! I’m almost flying!"),
        .init(maori: "Peke! He korikori tinana tēnei.", english: "Boing! That counts as exercise."),
        .init(maori: "Ki runga, ki raro — kua oho anō ahau!", english: "Up, down — I’m awake again!"),
        .init(maori: "Kāore e mau i te mahi tēnei kiwi!", english: "Work can’t catch this kiwi!"),
        .init(maori: "Kotahi anō te peke, kātahi ka whakatā.", english: "One more hop, then we rest.")
    ]

    static let forage: [ReminderMessage] = [
        .init(maori: "Hiakai, hiakai — ko te kai te mea nui ki te kiwi!", english: "Hungry, hungry — a kiwi lives for snacks!"),
        .init(maori: "He noke iti, he hākari nui!", english: "One tiny worm, one mighty feast!"),
        .init(maori: "Kai tuatahi, kātahi ko ngā whakaaro nui.", english: "Snack first. Great ideas later."),
        .init(maori: "Ehara tēnei i te whakaroa mahi — he kimi kai kē!", english: "I’m not procrastinating. I’m foraging."),
        .init(maori: "Kaua tētahi noke e mahue!", english: "No worm left behind!"),
        .init(maori: "Kua riro te kai, kua ora anō te ngākau!", english: "Snack acquired. Morale restored!"),
        .init(maori: "He ngārara reka pea kei konei.", english: "There might be a tasty bug down here."),
        .init(maori: "Mā te puku ora ka koa te kiwi.", english: "A happy tummy makes a happy kiwi.")
    ]

    static let sniff: [ReminderMessage] = [
        .init(maori: "Ka hongi au i te kai i raro i te whenua!", english: "I can smell snacks underground!"),
        .init(maori: "Kei te pito o taku ngutu ngā pongaponga ihu!", english: "My nostrils are at the tip of my beak!"),
        .init(maori: "Hongi, pao, ka kitea te kai!", english: "Sniff, probe, snack located!"),
        .init(maori: "Kāore he noke e huna i taku ihu.", english: "No worm can hide from this nose.")
    ]

    static let preen: [ReminderMessage] = [
        .init(maori: "He wā whakapaipai huruhuru.", english: "Feather maintenance time."),
        .init(maori: "He rā pōraruraru mō ngā huruhuru? Māku e whakatika.", english: "Bad feather day? I can fix that."),
        .init(maori: "He wā tiaki i a au anō.", english: "A tiny self-care break."),
        .init(maori: "He iti ngā parirau, he nui te whakapaipai.", english: "Tiny wings, serious grooming.")
    ]

    static let sleep: [ReminderMessage] = [
        .init(maori: "Ka moe tū te kiwi!", english: "A kiwi can sleep standing up!"),
        .init(maori: "Kaua e whakararuraru — kei te whakahiko anō ahau.", english: "Do not disturb — recharging."),
        .init(maori: "Ka hoki au ki taku rua moemoeā.", english: "Back to my dream burrow."),
        .init(maori: "Kua kati ngā karu, kua whakatā te mahi.", english: "Eyes closed. Work paused.")
    ]

    static let call: [ReminderMessage] = [
        .init(maori: "Kia rongo te ngahere: kei konei a Kukuda!", english: "Let the forest know: Kukuda is here!"),
        .init(maori: "Kei hea koe, e hoa?", english: "Where are you, friend?"),
        .init(maori: "He karanga nui nō tētahi kiwi iti!", english: "Big call, tiny kiwi!"),
        .init(maori: "Ko taku tēnei rohe — me taku wā whakatā hoki!", english: "My territory — and my break time too!")
    ]

    static let combo: [ReminderMessage] = [
        .init(maori: "Kua mau te kai — he peke toa ināianei!", english: "Snack secured — victory hop!"),
        .init(maori: "Kua kitea he noke — me kanikani!", english: "Found a worm — time for a victory dance!"),
        .init(maori: "Peke, kimi kai, kai, anō!", english: "Hop, forage, snack, repeat!"),
        .init(maori: "Kua kī te puku, kua rite mō te ngahau!", english: "Tummy full, ready for mischief!")
    ]

    static func randomRest(excluding current: ReminderMessage? = nil) -> ReminderMessage {
        let choices = rest.filter { $0 != current }
        return choices.randomElement() ?? rest[0]
    }

    static func randomPlay() -> ReminderMessage {
        play.randomElement() ?? play[0]
    }

    static func randomSprint() -> ReminderMessage {
        sprint.randomElement() ?? sprint[0]
    }

    static func randomSpin() -> ReminderMessage {
        spin.randomElement() ?? spin[0]
    }

    static func randomJump() -> ReminderMessage {
        jump.randomElement() ?? jump[0]
    }

    static func randomForage() -> ReminderMessage {
        forage.randomElement() ?? forage[0]
    }

    static func randomSniff() -> ReminderMessage {
        sniff.randomElement() ?? sniff[0]
    }

    static func randomPreen() -> ReminderMessage {
        preen.randomElement() ?? preen[0]
    }

    static func randomSleep() -> ReminderMessage {
        sleep.randomElement() ?? sleep[0]
    }

    static func randomCall() -> ReminderMessage {
        call.randomElement() ?? call[0]
    }

    static func randomCombo() -> ReminderMessage {
        combo.randomElement() ?? combo[0]
    }
}
