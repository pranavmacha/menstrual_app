import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _EducationTabBar(),
          SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              children: [
                _CycleBasicsContent(),
                _HygieneReliefContent(),
                _EcoFriendlyContent(),
                _MythsFactsContent(),
                _NutritionContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EducationTabBar extends StatelessWidget {
  const _EducationTabBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TabBar(
        isScrollable: true,
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textLight,
        tabs: const [
          Tab(text: 'Cycle Basics'),
          Tab(text: 'Hygiene & Relief'),
          Tab(text: 'Eco-Friendly'),
          Tab(text: 'Myths vs Facts'),
          Tab(text: 'Nutrition'),
        ],
      ),
    );
  }
}

class _CycleBasicsContent extends StatelessWidget {
  const _CycleBasicsContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Menstrual Cycle Overview'),
          const _InfoCard(
            title: 'What is the menstrual cycle?',
            body:
                'The menstrual cycle is a monthly hormonal process that prepares the body for pregnancy. '
                'A complete cycle typically lasts around 28 days, although anywhere between 21 and 35 days '
                'is considered normal.',
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Four Phases at a Glance'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _DetailCard(
                title: 'Menstrual phase',
                fields: [
                  _DetailField(label: 'Timing', value: 'Days 1–5'),
                  _DetailField(
                    label: 'Hormones',
                    value:
                        'Estrogen and progesterone are at their lowest levels.',
                  ),
                  _DetailField(
                    label: 'What happens',
                    value:
                        'The uterine lining sheds, leading to menstrual bleeding.',
                  ),
                ],
              ),
              _DetailCard(
                title: 'Follicular phase',
                fields: [
                  _DetailField(label: 'Timing', value: 'Days 1–13'),
                  _DetailField(
                    label: 'Hormones',
                    value:
                        'Estrogen rises while follicle-stimulating hormone activates ovarian follicles.',
                  ),
                  _DetailField(
                    label: 'What happens',
                    value:
                        'Follicles in the ovaries mature in preparation for ovulation.',
                  ),
                ],
              ),
              _DetailCard(
                title: 'Ovulation',
                fields: [
                  _DetailField(label: 'Timing', value: 'Around Day 14'),
                  _DetailField(
                    label: 'Hormones',
                    value:
                        'Estrogen peaks and triggers a luteinizing hormone surge.',
                  ),
                  _DetailField(
                    label: 'What happens',
                    value:
                        'A mature egg is released from the ovary and is available for fertilization.',
                  ),
                ],
              ),
              _DetailCard(
                title: 'Luteal phase',
                fields: [
                  _DetailField(label: 'Timing', value: 'Days 15–28'),
                  _DetailField(
                    label: 'Hormones',
                    value: 'Progesterone rises and estrogen remains present.',
                  ),
                  _DetailField(
                    label: 'What happens',
                    value:
                        'The corpus luteum produces progesterone to support a potential pregnancy.',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Common Symptoms'),
          const _InfoCard(
            title: 'Physical cues',
            body:
                'Cramps, bloating, breast tenderness, headaches, fatigue, and lower back pain are all common '
                'experiences throughout the cycle.',
          ),
          const SizedBox(height: 12),
          const _InfoCard(
            title: 'Emotional shifts',
            body:
                'Mood swings, irritability, anxiety, cravings, and dips in energy can appear as hormone levels change.',
          ),
          const SizedBox(height: 12),
          _CalloutCard(
            title: 'When to seek help',
            icon: Icons.health_and_safety,
            body:
                'Reach out to a healthcare professional if you experience severe pain, periods that last longer '
                'than seven days, very heavy bleeding, irregular cycles, or missed periods.',
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Tips for Tracking Your Cycle'),
          const _BulletList(
            items: [
              'Mark the first day of bleeding to establish your cycle start.',
              'Record the length of each period and any notable symptoms.',
              'Track at least three consecutive cycles to identify patterns.',
              'Share your tracking data with a healthcare provider if you have concerns.',
            ],
          ),
        ],
      ),
    );
  }
}

class _HygieneReliefContent extends StatelessWidget {
  const _HygieneReliefContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Hygiene Essentials'),
          const _InfoCard(
            title: 'Why menstrual hygiene matters',
            body:
                'Consistent hygiene routines help prevent infections and protect long-term reproductive health.',
          ),
          const SizedBox(height: 16),
          _DualColumnCard(
            leftTitle: 'Do’s',
            leftItems: const [
              'Change pads or tampons every 4–6 hours.',
              'Wash hands before and after changing products.',
              'Use mild, unscented soap around the vulva.',
              'Wear breathable cotton underwear.',
              'Shower or bathe regularly.',
              'Store period products in a clean, dry place.',
              'Dispose of used products properly.',
              'Stay hydrated throughout the day.',
            ],
            rightTitle: 'Don’ts',
            rightItems: const [
              'Avoid scented products or douching.',
              'Do not wear the same product for too long.',
              'Never flush pads or tampons.',
              'Skip using expired products.',
              'Limit tight synthetic clothing for long stretches.',
              'Do not ignore unusual symptoms or odors.',
              'Never share personal hygiene products.',
              'Avoid swimming or bathing with a tampon left in for long periods.',
            ],
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Natural Relief Options'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _TagChip(label: 'Heat therapy'),
              _TagChip(label: 'Gentle exercise'),
              _TagChip(label: 'Hydration'),
              _TagChip(label: 'Balanced meals'),
              _TagChip(label: 'Rest and deep breathing'),
              _TagChip(label: 'Light massage'),
              _TagChip(label: 'Herbal tea'),
              _TagChip(label: 'Quality sleep'),
            ],
          ),
          const SizedBox(height: 16),
          _CalloutCard(
            title: 'Toxic Shock Syndrome awareness',
            icon: Icons.warning,
            body:
                'If you use tampons, change them every 4–6 hours and seek immediate care if you notice fever, '
                'rash, or vomiting.',
          ),
          const SizedBox(height: 12),
          _CalloutCard(
            title: 'When to check in with a doctor',
            icon: Icons.local_hospital,
            body:
                'Schedule an appointment for severe cramps, periods lasting longer than seven days, soaking '
                'through a pad or tampon every hour, unusually frequent cycles, or unexpected discharge.',
          ),
          const SizedBox(height: 12),
          const _InfoCard(
            title: 'Product safety reminder',
            body:
                'Choose products from reputable brands and follow the instructions on the packaging for the safest experience.',
          ),
        ],
      ),
    );
  }
}

class _EcoFriendlyContent extends StatelessWidget {
  const _EcoFriendlyContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Why go eco-friendly?'),
          const _InfoCard(
            title: 'Small swaps, big impact',
            body:
                'Disposable period products contribute to pollution. Reusable options reduce waste, save money, '
                'and often use gentler materials.',
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Benefits of sustainable products'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _InfoCard(
                title: 'Environmental impact',
                body:
                    'One person can use up to 11,000 disposable period products in a lifetime. '
                    'Choosing reusables keeps plastics out of landfills and waterways.',
              ),
              _InfoCard(
                title: 'Cost savings',
                body:
                    'A quality menstrual cup can last 5-10 years and save more than \$1,500 over its lifespan.',
              ),
              _InfoCard(
                title: 'Health benefits',
                body:
                    'Reusable products usually contain fewer chemicals and can reduce irritation.',
              ),
              _InfoCard(
                title: 'Sustainability',
                body:
                    'Switching to reusable pads or period underwear lowers plastic waste and ocean pollution.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _DetailCard(
                title: 'Menstrual cup',
                fields: [
                  _DetailField(label: 'Lifespan', value: '5–10 years'),
                  _DetailField(label: 'Cost', value: r'$25–40'),
                  _DetailField(label: 'Eco rating', value: 'Excellent'),
                  _DetailField(
                    label: 'Pros',
                    value:
                        'Reusable, cost-effective, and long-lasting for heavy or light flows.',
                  ),
                  _DetailField(
                    label: 'Considerations',
                    value:
                        'Requires cleaning and a bit of practice to insert comfortably.',
                  ),
                ],
              ),
              _DetailCard(
                title: 'Period underwear',
                fields: [
                  _DetailField(label: 'Lifespan', value: '2–3 years'),
                  _DetailField(label: 'Cost', value: r'$15–35 per pair'),
                  _DetailField(label: 'Eco rating', value: 'Excellent'),
                  _DetailField(
                    label: 'Pros',
                    value:
                        'Comfortable, leak-resistant, and easy to wear without extra products.',
                  ),
                  _DetailField(
                    label: 'Considerations',
                    value:
                        'Higher upfront cost and needs routine washing between wears.',
                  ),
                ],
              ),
              _DetailCard(
                title: 'Reusable pads',
                fields: [
                  _DetailField(label: 'Lifespan', value: '3–5 years'),
                  _DetailField(label: 'Cost', value: r'$10–25 per set'),
                  _DetailField(label: 'Eco rating', value: 'Excellent'),
                  _DetailField(
                    label: 'Pros',
                    value:
                        'Soft, breathable fabrics with customizable absorbency levels.',
                  ),
                  _DetailField(
                    label: 'Considerations',
                    value:
                        "Need frequent washing and you'll want multiple sets for rotation.",
                  ),
                ],
              ),
              _DetailCard(
                title: 'Organic cotton pads',
                fields: [
                  _DetailField(label: 'Lifespan', value: 'Single-use'),
                  _DetailField(label: 'Cost', value: r'$5–8 per box'),
                  _DetailField(label: 'Eco rating', value: 'Good'),
                  _DetailField(
                    label: 'Pros',
                    value:
                        'Biodegradable, chlorine-free materials that feel similar to regular pads.',
                  ),
                  _DetailField(
                    label: 'Considerations',
                    value:
                        'Still disposable, so there is ongoing cost and waste.',
                  ),
                ],
              ),
              _DetailCard(
                title: 'Organic tampons',
                fields: [
                  _DetailField(label: 'Lifespan', value: 'Single-use'),
                  _DetailField(label: 'Cost', value: r'$6–10 per box'),
                  _DetailField(label: 'Eco rating', value: 'Good'),
                  _DetailField(
                    label: 'Pros',
                    value:
                        'Made with biodegradable fibers and familiar to tampon users.',
                  ),
                  _DetailField(
                    label: 'Considerations',
                    value:
                        'Disposable product that still needs restocking and proper disposal.',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Transition tips'),
          const _BulletList(
            items: [
              'Start by trying one reusable product that fits your lifestyle.',
              'Read reviews and check sizing guides before purchasing.',
              'Match the product to your typical flow for comfort and protection.',
              'Allow time to adjust—every new product has a learning curve.',
              'Follow care instructions to help products last longer.',
            ],
          ),
        ],
      ),
    );
  }
}

class _MythsFactsContent extends StatelessWidget {
  const _MythsFactsContent();

  @override
  Widget build(BuildContext context) {
    final myths = <Map<String, String>>[
      {
        'myth': 'You can’t swim or exercise during your period.',
        'fact': 'You absolutely can. Movement can ease cramps and boost mood.',
      },
      {
        'myth': 'Periods sync when people spend time together.',
        'fact':
            'There is no scientific evidence that cycles truly synchronize.',
      },
      {
        'myth': 'You lose a lot of blood during your period.',
        'fact':
            'Most people lose only 2–3 tablespoons (30–40 ml) of menstrual fluid.',
      },
      {
        'myth': 'You can’t get pregnant during your period.',
        'fact':
            'Pregnancy is still possible because sperm can survive up to five days.',
      },
      {
        'myth': 'Tampons can get lost inside you.',
        'fact': 'The cervix blocks the way—tampons can always be removed.',
      },
      {
        'myth': 'PMS is just in your head.',
        'fact':
            'Premenstrual syndrome is real and affects roughly 75% of menstruating people.',
      },
      {
        'myth': 'Irregular periods always mean something is wrong.',
        'fact':
            'Cycles can vary, especially during the teen years or perimenopause. Sudden changes are worth discussing with a doctor.',
      },
      {
        'myth': 'You shouldn’t wash your hair on your period.',
        'fact':
            'There is no scientific basis—good hygiene is especially helpful.',
      },
      {
        'myth': 'Period blood is dirty.',
        'fact':
            'Menstrual fluid is a mix of blood, uterine tissue, and secretions. It is not toxic.',
      },
      {
        'myth': 'Severe pain is normal.',
        'fact':
            'Intense pain may signal conditions such as endometriosis. Seek medical advice.',
      },
      {
        'myth': 'Cooking certain foods or using tampons affects virginity.',
        'fact':
            'These are cultural myths. Menstruation does not change your ability to cook, and virginity is a social concept.',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Myths vs Facts'),
          ...myths.map(
            (item) => _MythFactCard(myth: item['myth']!, fact: item['fact']!),
          ),
          const SizedBox(height: 20),
          const _InfoCard(
            title: 'Why myths stick around',
            body:
                'Menstrual myths often persist because of cultural taboos, limited education, and the silence that surrounds menstruation. '
                'Open conversations and reliable information help break the cycle.',
          ),
        ],
      ),
    );
  }
}

class _NutritionContent extends StatelessWidget {
  const _NutritionContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Nutrition Foundations'),
          const _InfoCard(
            title: 'Why food choices matter',
            body:
                'What you eat can influence menstrual symptoms, energy levels, and hormone balance throughout the cycle.',
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Essential nutrients'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _InfoCard(
                title: 'Iron',
                body:
                    'Replenishes iron lost during bleeding and helps prevent anemia. Sources include lean red meat, leafy greens, lentils, and fortified cereals.',
              ),
              _InfoCard(
                title: 'Magnesium',
                body:
                    'Can ease cramps, bloating, and mood swings. Look for nuts, seeds, whole grains, dark chocolate, and avocados.',
              ),
              _InfoCard(
                title: 'Omega-3 fatty acids',
                body:
                    'Offer anti-inflammatory benefits that may reduce period pain. Add fatty fish, flaxseeds, chia seeds, and walnuts to meals.',
              ),
              _InfoCard(
                title: 'Vitamin B6',
                body:
                    'Supports neurotransmitters that influence mood. Chickpeas, bananas, chicken, and potatoes are rich sources.',
              ),
              _InfoCard(
                title: 'Calcium',
                body:
                    'Linked to reduced cramps and mood swings. Enjoy dairy, fortified plant milks, and leafy greens.',
              ),
              _InfoCard(
                title: 'Vitamin D',
                body:
                    'May help with inflammation and pain management. Get sunlight exposure and include fatty fish or fortified foods.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _DetailCard(
                title: 'Heme iron highlights',
                fields: [
                  _DetailField(
                    label: 'Sources',
                    value:
                        'Beef, chicken liver, seafood, and other animal proteins.',
                  ),
                  _DetailField(
                    label: 'Why it helps',
                    value:
                        'Absorbs easily and quickly replenishes iron lost during menstruation.',
                  ),
                  _DetailField(
                    label: 'Tip',
                    value:
                        'Pair with fiber-rich sides like veggies or whole grains for balance.',
                  ),
                ],
              ),
              _DetailCard(
                title: 'Non-heme iron boosters',
                fields: [
                  _DetailField(
                    label: 'Sources',
                    value:
                        'Spinach, lentils, beans, tofu, pumpkin seeds, and fortified cereals.',
                  ),
                  _DetailField(
                    label: 'Why it helps',
                    value:
                        'Plant-based iron supports energy and is great for vegetarian or vegan diets.',
                  ),
                  _DetailField(
                    label: 'Tip',
                    value:
                        'Eat with vitamin C foods such as citrus, bell peppers, or strawberries to boost absorption.',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Eat with your cycle'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _InfoCard(
                title: 'Menstrual phase (Days 1–5)',
                body:
                    'Focus on iron-rich and anti-inflammatory foods such as lean red meat, liver, leafy greens, ginger, turmeric, berries, and fatty fish.',
              ),
              _InfoCard(
                title: 'Follicular phase (Days 6–14)',
                body:
                    'Choose light, energizing meals with eggs, lean proteins, fermented foods, citrus fruits, whole grains, and pumpkin seeds.',
              ),
              _InfoCard(
                title: 'Ovulation (Day 14)',
                body:
                    'Center meals around anti-inflammatory, fiber-rich foods like colorful vegetables, quinoa, nuts, salmon, leafy greens, and berries.',
              ),
              _InfoCard(
                title: 'Luteal phase (Days 15–28)',
                body:
                    'Prioritize complex carbs and B-vitamin sources such as sweet potatoes, brown rice, chickpeas, dark chocolate, bananas, and leafy greens.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Everyday nutrition tips'),
          const _BulletList(
            items: [
              'Stay hydrated by sipping water throughout the day.',
              'Enjoy smaller, frequent meals to stabilize energy.',
              'Pair plant-based iron sources with vitamin C for better absorption.',
              'Soothe cramps with herbal teas like ginger, chamomile, or peppermint.',
              'Reduce caffeine and salty processed foods to minimize bloating.',
              'Limit added sugars and moderate alcohol intake.',
              'Notice how dairy affects your body and adjust if it causes discomfort.',
            ],
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Sample meal ideas'),
          const _BulletList(
            items: [
              'Breakfast: Spinach and mushroom omelet with whole-grain toast.',
              'Lunch: Quinoa bowl with chickpeas, roasted vegetables, and tahini dressing.',
              'Dinner: Grilled chicken or tofu with sweet potato and steamed broccoli.',
              'Snacks: Almonds, an apple with almond butter, dark chocolate squares, or hummus with carrot sticks.',
            ],
          ),
          const SizedBox(height: 16),
          _CalloutCard(
            title: 'Remember',
            icon: Icons.info_outline,
            body:
                'Nutrition tips are educational. Always consult a healthcare professional for personalized advice, especially if you have underlying conditions.',
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String body;

  const _InfoCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(body, style: const TextStyle(fontSize: 14, height: 1.4)),
          ],
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;

  const _BulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CalloutCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  const _CalloutCard({
    required this.title,
    required this.body,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.accent.withOpacity(0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(body, style: const TextStyle(fontSize: 14, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailField {
  final String label;
  final String value;

  const _DetailField({required this.label, required this.value});
}

class _DetailCard extends StatelessWidget {
  final String title;
  final List<_DetailField> fields;

  const _DetailCard({required this.title, required this.fields});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...fields.map(
                (field) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field.label,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        field.value,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DualColumnCard extends StatelessWidget {
  final String leftTitle;
  final List<String> leftItems;
  final String rightTitle;
  final List<String> rightItems;

  const _DualColumnCard({
    required this.leftTitle,
    required this.leftItems,
    required this.rightTitle,
    required this.rightItems,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 600;
            Widget buildColumn(String title, List<String> items) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _BulletList(items: items),
                ],
              );
            }

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildColumn(leftTitle, leftItems),
                  const SizedBox(height: 16),
                  buildColumn(rightTitle, rightItems),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: buildColumn(leftTitle, leftItems)),
                const SizedBox(width: 16),
                Expanded(child: buildColumn(rightTitle, rightItems)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: AppColors.accent.withOpacity(0.6),
      label: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}

class _MythFactCard extends StatelessWidget {
  final String myth;
  final String fact;

  const _MythFactCard({required this.myth, required this.fact});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Myth',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(myth, style: const TextStyle(fontSize: 14, height: 1.4)),
            const SizedBox(height: 12),
            const Text(
              'Fact',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(fact, style: const TextStyle(fontSize: 14, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
