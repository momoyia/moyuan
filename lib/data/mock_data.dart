import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_assets.dart';
import 'package:peiban_app/models/article.dart';
import 'package:peiban_app/models/article_section.dart';
import 'package:peiban_app/models/course.dart';
import 'package:peiban_app/models/daily_plan.dart';
import 'package:peiban_app/models/diet_guide.dart';
import 'package:peiban_app/models/featured_topic.dart';
import 'package:peiban_app/models/recipe.dart';
import 'package:peiban_app/models/social_user_entry.dart';
import 'package:peiban_app/models/topic_science_phase.dart';
import 'package:peiban_app/models/workout_action.dart';

class MockData {
  MockData._();

  static const List<String> homeCategories = [
    '全部推荐',
    '腹肌撕裂',
    '马甲线塑造',
    '有效臀大肌',
    '拉伸放松',
  ];

  static const List<String> featuredTabs = [
    '热门专题',
    '科学减脂',
    '核心突破',
    '康复拉伸',
  ];

  static const List<Map<String, dynamic>> workoutFocusOptions = [
    {
      'id': 'abs',
      'label': '腹部核心',
      'subtitle': '马甲线 · 腹肌雕刻',
      'icon': Icons.self_improvement_outlined,
    },
    {
      'id': 'cardio',
      'label': '全身燃脂',
      'subtitle': 'HIIT · 高效减脂',
      'icon': Icons.local_fire_department_outlined,
    },
    {
      'id': 'stretch',
      'label': '肩颈拉伸',
      'subtitle': '久坐康复 · 体态改善',
      'icon': Icons.spa_outlined,
    },
  ];

  static const List<String> recipeCategories = [
    '减脂主食',
    '高纤沙拉',
    '优质蛋白',
    '燃脂饮品',
  ];

  static const List<String> feedbackTypes = [
    '功能建议',
    '问题反馈',
    '内容投诉',
    '其他',
  ];

  static final List<SocialUserEntry> defaultBlockedUsers = [
    const SocialUserEntry(
      id: 'user_001',
      nickname: '健身小白鸭',
      avatarAsset: 'assets/images/avatar_cartoon.jpg',
    ),
    const SocialUserEntry(
      id: 'user_002',
      nickname: '深夜撸铁王',
      avatarAsset: 'assets/images/avatar_food.jpg',
    ),
  ];

  static final List<SocialUserEntry> defaultMutedUsers = [
    const SocialUserEntry(
      id: 'user_003',
      nickname: '卡路里计算器',
      avatarAsset: 'assets/images/avatar_scenery.jpg',
    ),
    const SocialUserEntry(
      id: 'user_004',
      nickname: '马甲线打卡官',
      avatarAsset: 'assets/images/avatar_animal.jpg',
    ),
    const SocialUserEntry(
      id: 'user_005',
      nickname: '瑜伽小仙女',
      avatarAsset: 'assets/images/avatar_cartoon.jpg',
    ),
  ];

  static const List<String> onboardingInterests = [
    '减脂燃脂',
    '腹肌撕裂',
    '马甲线塑造',
    '臀腿塑形',
    '拉伸放松',
  ];

  static const List<Map<String, String>> fitnessPlans = [
    {
      'id': 'plan_21',
      'title': '21天减脂特训计划',
      'subtitle': '全身燃脂 · 循序渐进',
    },
    {
      'id': 'plan_14',
      'title': '14天马甲线速成',
      'subtitle': '核心强化 · 每日打卡',
    },
    {
      'id': 'plan_7',
      'title': '7天轻断食配合训练',
      'subtitle': '饮食+运动双管齐下',
    },
  ];

  static final List<Course> courses = [
    Course(
      id: 'course_hiit',
      title: '全身高强度间歇燃脂 (HIIT)',
      description: '今日核心训练计划，快速提升心率，高效燃烧脂肪。',
      category: '全部推荐',
      tag: '减脂核心',
      tagColor: 0xFFFFE4EC,
      durationMinutes: 25,
      calories: 280,
      imageAsset: AppAssets.courseHiit,
      difficulty: '进阶级',
      steps: [
        '热身慢跑 3 分钟，活动关节。',
        '波比跳 45 秒，休息 15 秒，重复 4 组。',
        '高抬腿 40 秒，休息 20 秒，重复 4 组。',
        '登山跑 45 秒，休息 15 秒，重复 4 组。',
        '拉伸放松 5 分钟，深呼吸调整。',
      ],
    ),
    Course(
      id: 'course_jump',
      title: '15分钟黄金无跳跃全身燃脂',
      description: '适合膝盖友好、不扰民的居家高效减脂课程。',
      category: '全部推荐',
      tag: '减脂核心',
      tagColor: 0xFFFFE4EC,
      durationMinutes: 15,
      calories: 140,
      imageAsset: AppAssets.courseJump,
      difficulty: '初级',
      steps: [
        '原地踏步热身 2 分钟。',
        '深蹲触地 40 秒 × 3 组。',
        '侧弓步 40 秒 × 3 组。',
        '平板支撑交替触肩 30 秒 × 4 组。',
        '全身拉伸 3 分钟。',
      ],
    ),
    Course(
      id: 'course_abs',
      title: '腹肌撕裂者 · 核心强化',
      description: '针对腹直肌与腹斜肌，打造清晰马甲线。',
      category: '腹肌撕裂',
      tag: '腹肌撕裂',
      tagColor: 0xFFFFE4EC,
      durationMinutes: 18,
      calories: 160,
      imageAsset: AppAssets.courseAbs,
      difficulty: '中级',
      steps: [
        '卷腹 20 次 × 3 组。',
        '俄罗斯转体 30 次 × 3 组。',
        '仰卧举腿 15 次 × 3 组。',
        '平板支撑 60 秒 × 3 组。',
        '猫牛式拉伸放松。',
      ],
    ),
    Course(
      id: 'course_line',
      title: '马甲线塑造专项训练',
      description: '聚焦核心稳定与腹斜肌，雕刻腰腹线条。',
      category: '马甲线塑造',
      tag: '马甲线',
      tagColor: 0xFFF3E8FF,
      durationMinutes: 20,
      calories: 180,
      imageAsset: AppAssets.courseYoga,
      difficulty: '中级',
      steps: [
        '死虫式 12 次 × 3 组。',
        '侧平板支撑左右各 45 秒。',
        '自行车卷腹 30 次 × 3 组。',
        'V 字起身 12 次 × 3 组。',
      ],
    ),
    Course(
      id: 'course_back',
      title: '直角肩与优雅薄背塑形法',
      description: '改善圆肩驼背，重塑迷人背部线条。',
      category: '马甲线塑造',
      tag: '塑形美背',
      tagColor: 0xFFF3E8FF,
      durationMinutes: 20,
      calories: 190,
      imageAsset: AppAssets.courseBack,
      difficulty: '初级',
      steps: [
        'YTWL 肩胛激活 12 次 × 3 组。',
        '俯身飞鸟 15 次 × 3 组。',
        '弹力带面拉 15 次 × 3 组。',
        '胸椎伸展 1 分钟。',
      ],
    ),
    Course(
      id: 'course_glutes',
      title: '有效臀大肌激活训练',
      description: '唤醒臀部肌群，提升下肢力量与线条。',
      category: '有效臀大肌',
      tag: '臀腿塑形',
      tagColor: 0xFFFFF7ED,
      durationMinutes: 22,
      calories: 200,
      imageAsset: AppAssets.courseGlutes,
      difficulty: '中级',
      steps: [
        '臀桥 20 次 × 4 组。',
        '蚌式开合 20 次 × 3 组。',
        '保加利亚分腿蹲 12 次 × 3 组。',
        '后踢腿 15 次 × 3 组。',
      ],
    ),
    Course(
      id: 'course_stretch',
      title: '全身拉伸放松修复',
      description: '训练后必做，缓解肌肉紧张，提升柔韧性。',
      category: '拉伸放松',
      tag: '拉伸放松',
      tagColor: 0xFFECFDF5,
      durationMinutes: 12,
      calories: 60,
      imageAsset: AppAssets.courseStretch,
      difficulty: '放松级',
      steps: [
        '颈部环绕与侧拉各 30 秒。',
        '猫牛式、下犬式各 1 分钟。',
        '鸽子式左右各 45 秒。',
        '婴儿式放松 1 分钟。',
      ],
    ),
  ];

  static final List<Recipe> recipes = [
    Recipe(
      id: 'recipe_salad',
      title: '牛油果全麦鲜虾轻食碗',
      description: '优质脂脂 + 高纤蛋白，全方位满足营养需求。',
      calories: 320,
      protein: 24,
      carbs: 30,
      fat: 10,
      category: '高纤沙拉',
      imageAsset: AppAssets.recipeSalad,
      ingredients: ['鲜虾 120g', '牛油果半个', '全麦谷物 80g', '混合生菜', '柠檬汁'],
      steps: ['虾仁焯水备用', '牛油果切块', '谷物与蔬菜打底', '摆盘淋柠檬汁'],
    ),
    Recipe(
      id: 'recipe_chicken',
      title: '香煎鸡胸肉配烤时蔬',
      description: '经典低脂不发胖，高蛋白增肌必备餐单。',
      calories: 285,
      protein: 35,
      carbs: 12,
      fat: 6,
      category: '优质蛋白',
      imageAsset: AppAssets.recipeChicken,
      ingredients: ['鸡胸肉 150g', '西兰花', '彩椒', '橄榄油 5ml', '黑胡椒'],
      steps: ['鸡胸肉腌制', '平底锅少油煎熟', '时蔬烤箱180度15分钟', '装盘即可'],
    ),
    Recipe(
      id: 'recipe_oatmeal',
      title: '燕麦藜麦减脂主食碗',
      description: '低 GI 碳水，持久饱腹感，减脂期主食首选。',
      calories: 260,
      protein: 12,
      carbs: 42,
      fat: 5,
      category: '减脂主食',
      imageAsset: AppAssets.recipeOatmeal,
      ingredients: ['燕麦 40g', '藜麦 30g', '蓝莓', '无糖酸奶'],
      steps: ['燕麦藜麦煮熟', '加入蓝莓', '淋酸奶', '可撒坚果碎'],
    ),
    Recipe(
      id: 'recipe_smoothie',
      title: '抹茶蛋白燃脂奶昔',
      description: '训练后补充蛋白质，清爽低卡无负担。',
      calories: 180,
      protein: 22,
      carbs: 15,
      fat: 3,
      category: '燃脂饮品',
      imageAsset: AppAssets.recipeSmoothie,
      ingredients: ['蛋白粉 1勺', '抹茶粉 3g', '脱脂牛奶 200ml', '冰块'],
      steps: ['所有材料入搅拌机', '高速打匀 30 秒', '即可饮用'],
    ),
    Recipe(
      id: 'recipe_egg',
      title: '菠菜蘑菇蛋白烘蛋',
      description: '优质蛋白早餐，开启元气满满的一天。',
      calories: 210,
      protein: 18,
      carbs: 8,
      fat: 12,
      category: '优质蛋白',
      imageAsset: AppAssets.recipeEgg,
      ingredients: ['鸡蛋 3个', '菠菜 50g', '蘑菇 80g', '低脂奶酪'],
      steps: ['蔬菜炒香', '倒入蛋液', '小火烘至凝固', '撒奶酪出锅'],
    ),
    Recipe(
      id: 'recipe_bowl',
      title: '彩虹蔬菜杂粮饭',
      description: '多彩蔬菜搭配杂粮，维生素与纤维满满。',
      calories: 295,
      protein: 10,
      carbs: 48,
      fat: 7,
      category: '减脂主食',
      imageAsset: AppAssets.recipeBowl,
      ingredients: ['糙米 60g', '玉米粒', '胡萝卜', '黄瓜', '紫甘蓝'],
      steps: ['糙米蒸熟', '蔬菜切丁', '拌匀调味', '装碗享用'],
    ),
  ];

  static final List<FeaturedTopic> topics = [
    FeaturedTopic(
      id: 'topic_abs',
      title: '马甲线与腹肌速成班',
      badge: '21天挑战',
      participants: '1.4w',
      imageAsset: AppAssets.topicAbs,
      description: '21天系统训练，从核心激活到腹肌雕刻，每日跟练打卡。',
      days: 21,
      scienceIntro: '腹肌可见度取决于体脂率与核心肌群发展。本专题基于「神经肌肉激活 → 肌耐力提升 → 体脂管理」三阶段模型，帮助你在科学周期内改善腰腹线条。',
      principles: [
        '核心稳定优先于卷腹数量，深层肌群激活是第一步',
        '腹直肌与腹斜肌需均衡刺激，避免单侧过度发展',
        '体脂率女性约 20% 以下、男性约 15% 以下腹肌线条更易显现',
      ],
      suitableFor: ['有一定运动基础', '腰腹脂肪适中', '希望改善体态者'],
      cautions: ['腰椎间盘突出急性期勿练', '产后需医生评估后恢复', '避免每日高强度卷腹导致颈部代偿'],
      phases: const [
        TopicSciencePhase(
          title: '神经激活期',
          duration: '第 1–7 天',
          focus: '唤醒腹横肌与多裂肌',
          explanation: '通过死虫式、腹式呼吸等低负荷动作，重建核心控制能力，为后续训练打基础。',
        ),
        TopicSciencePhase(
          title: '肌耐力提升期',
          duration: '第 8–14 天',
          focus: '增加时间 under tension',
          explanation: '引入平板支撑变式、慢速卷腹，提升肌群耐受力，建议每组 30–45 秒持续紧张。',
        ),
        TopicSciencePhase(
          title: '线条雕刻期',
          duration: '第 15–21 天',
          focus: '结合有氧与核心训练',
          explanation: '在保持核心训练的同时配合 HIIT，通过热量缺口降低体脂，让腹肌线条逐渐显现。',
        ),
      ],
      facts: const [
        ScienceFact(label: '建议体脂', value: '女 ≤22% / 男 ≤18%', note: '个体差异存在，以腰围变化为辅助指标'),
        ScienceFact(label: '核心训练频率', value: '每周 4–5 次', note: '肌群需 48h 恢复，避免每天高强度'),
        ScienceFact(label: '蛋白质摄入', value: '1.4–1.8 g/kg', note: '支持肌肉修复，防止减脂期肌肉流失'),
      ],
      expertTip: '腹肌是「练出来」更是「吃出来」的——没有热量缺口，再强的核心也难见线条。',
    ),
    FeaturedTopic(
      id: 'topic_cardio',
      title: '全身燃脂轰炸计划',
      badge: '高效无氧',
      participants: '9.8k',
      imageAsset: AppAssets.topicCardio,
      description: '结合 HIIT 与力量训练，最大化热量消耗。',
      days: 14,
      scienceIntro: 'HIIT 通过短时间高强度刺激提升心率至最大心率的 80–95%，运动后过量氧耗（EPOC）可使代谢在 24–48 小时内保持升高，是时间效率极高的燃脂策略。',
      principles: [
        '高强度与充分恢复交替，工作休息比建议 1:1 或 1:2',
        '全身大肌群参与的动作消耗更高，优先复合动作',
        '每周不超过 3–4 次 HIIT，避免皮质醇持续升高',
      ],
      suitableFor: ['心肺功能良好', '有一定训练基础', '时间有限需高效燃脂者'],
      cautions: ['初学者应从低强度有氧入门', '高血压患者需医嘱', '关节不适者避免跳跃类动作'],
      phases: const [
        TopicSciencePhase(
          title: '有氧基础期',
          duration: '第 1–4 天',
          focus: '提升心肺适应能力',
          explanation: '中等强度有氧（心率 60–70% HRmax）为主，让身体适应运动负荷，降低受伤风险。',
        ),
        TopicSciencePhase(
          title: '间歇进阶期',
          duration: '第 5–10 天',
          focus: '引入 HIIT 循环',
          explanation: '30 秒高强度 + 30 秒休息，逐步提升至 40:20，监测心率恢复速度作为进步指标。',
        ),
        TopicSciencePhase(
          title: '代谢巩固期',
          duration: '第 11–14 天',
          focus: '混合训练与恢复',
          explanation: 'HIIT 与力量训练交替，保证 1–2 天低强度恢复，巩固代谢提升效果。',
        ),
      ],
      facts: const [
        ScienceFact(label: '目标心率', value: '80–95% HRmax', note: 'HRmax ≈ 220 − 年龄'),
        ScienceFact(label: 'EPOC 持续', value: '24–48 小时', note: '运动后额外热量消耗效应'),
        ScienceFact(label: '单次时长', value: '20–30 分钟', note: '含热身与拉伸，质量优于时长'),
      ],
      expertTip: 'HIIT 不是每天都做——过度高频反而增加受伤与代谢紊乱风险，科学安排休息同样重要。',
    ),
    FeaturedTopic(
      id: 'topic_stretch',
      title: '办公室肩颈康复拉伸',
      badge: '康复拉伸',
      participants: '6.2k',
      imageAsset: AppAssets.topicStretch,
      description: '缓解久坐疲劳，改善体态，适合每日碎片时间练习。',
      days: 7,
      scienceIntro: '久坐导致胸大肌、髂腰肌缩短，上交叉综合征（头前倾、圆肩）是常见体态问题。拉伸通过延长紧张肌群、激活弱化肌群，恢复关节正常活动范围。',
      principles: [
        '静态拉伸保持 30–60 秒，避免弹震式拉伸',
        '拉伸至轻微牵拉感即可，不应有尖锐疼痛',
        '配合胸肌放松与中下斜方肌激活，效果更佳',
      ],
      suitableFor: ['久坐办公族', '肩颈僵硬酸痛者', '运动后放松恢复'],
      cautions: ['急性炎症或扭伤期勿拉伸', '颈椎病严重者需理疗师指导', '拉伸时保持自然呼吸'],
      phases: const [
        TopicSciencePhase(
          title: '紧张评估期',
          duration: '第 1–2 天',
          focus: '识别主要紧张区域',
          explanation: '通过颈部活动度、肩关节外旋测试，判断胸肌、斜方肌上束等紧张程度。',
        ),
        TopicSciencePhase(
          title: '渐进松解期',
          duration: '第 3–5 天',
          focus: '每日 2 次短时拉伸',
          explanation: '每次 5–10 分钟，重点拉伸胸大肌、肩胛提肌、上斜方肌，配合泡沫轴效果更佳。',
        ),
        TopicSciencePhase(
          title: '体态巩固期',
          duration: '第 6–7 天',
          focus: '建立日常习惯',
          explanation: '将拉伸嵌入工作间隙，每 45–60 分钟起身活动，配合肩胛后缩练习强化弱侧肌群。',
        ),
      ],
      facts: const [
        ScienceFact(label: '单次拉伸', value: '30–60 秒', note: '重复 2–3 次，双侧交替'),
        ScienceFact(label: '建议频率', value: '每日 2–3 次', note: '办公间隙即可进行'),
        ScienceFact(label: '改善周期', value: '2–4 周', note: '持续坚持可见体态变化'),
      ],
      expertTip: '拉伸不是越痛越好——轻微牵拉感下肌肉才会放松，强行拉扯可能引发保护性痉挛。',
    ),
  ];

  static final List<WorkoutAction> actions = [
    WorkoutAction(
      id: 'action_burpee',
      name: '波比跳燃脂特训',
      subtitle: '全身复合燃脂动作，消耗极大',
      sets: '3组 × 15次',
      imageAsset: AppAssets.actionBurpee,
      rating: 9.1,
      difficultyLabel: 'K3 进阶',
      durationMinutes: 12,
      caloriesMin: 68,
      caloriesMax: 95,
      authorName: '教练小林',
      authorAvatar: AppAssets.avatarAnimal,
      description: '全身复合动作，结合深蹲、俯卧撑与跳跃，快速提升心率。适合有一定基础的用户，注意落地缓冲与核心收紧，循序渐进增加次数。',
      commentCount: 286,
      practicedLabel: '8.6万',
      equipment: const ['瑜伽垫', '运动手环'],
      tips: ['落地时膝盖微屈缓冲', '核心收紧保持背部平直', '循序渐进增加次数'],
      targetMuscles: ['股四头肌', '臀大肌', '胸大肌', '三角肌', '核心肌群'],
      biomechanics: '波比跳是深蹲、平板支撑、跳跃的复合动作。下蹲阶段髋膝同时屈曲，推起阶段通过髋伸展产生爆发力，落地时离心收缩吸收冲击力。全身多关节协同，能量消耗显著高于孤立动作。',
      commonMistakes: [
        '落地时膝盖内扣，增加 ACL 损伤风险',
        '俯卧撑阶段塌腰，腰椎承受过大剪切力',
        '为了追求速度牺牲动作质量',
      ],
      breathingGuide: [
        '下蹲时吸气，蓄力准备',
        '推起跳跃时呼气，核心收紧',
        '落地缓冲时吸气，控制下降',
      ],
      intensityGuide: 'RPE 8–9（接近力竭）。心率可达最大心率的 85–95%，适合作为 HIIT 主训动作，组间休息 30–60 秒。',
      scienceBenefits: [
        '单位时间热量消耗约 10–14 kcal/min',
        '提升心肺适能与无氧耐力',
        '增强全身协调性与爆发力',
      ],
    ),
    WorkoutAction(
      id: 'action_plank',
      name: '平板支撑核心强化',
      subtitle: '核心肌群强化，紧致腰腹线条',
      sets: '4组 × 60秒',
      imageAsset: AppAssets.actionPlank,
      rating: 8.8,
      difficultyLabel: 'K2 初学',
      durationMinutes: 10,
      caloriesMin: 35,
      caloriesMax: 52,
      authorName: '瑜伽老师Amy',
      authorAvatar: AppAssets.avatars[2],
      description: '低冲击核心训练，通过等长收缩激活腹横肌与多裂肌。全程保持脊柱中立，均匀呼吸，适合新手建立核心控制能力。',
      commentCount: 412,
      practicedLabel: '12.3万',
      equipment: const ['瑜伽垫'],
      tips: ['肘部位于肩正下方', '臀部不要翘起或下沉', '均匀呼吸不要憋气'],
      targetMuscles: ['腹横肌', '腹直肌', '竖脊肌', '臀大肌', '前锯肌'],
      biomechanics: '平板支撑是等长收缩训练，腹横肌和多裂肌作为深层稳定肌持续发力，维持脊柱中立位。肘撑相比直臂支撑，减少了肩关节负荷，更适合初学者激活核心。',
      commonMistakes: [
        '塌腰导致腰椎超伸，椎间盘压力增大',
        '撅臀使髋屈肌代偿，核心刺激减弱',
        '憋气导致血压波动，应均匀呼吸',
      ],
      breathingGuide: [
        '保持腹式呼吸，吸气时腹部微微隆起',
        '呼气时收紧腹横肌，想象肚脐贴向脊柱',
        '全程避免屏气，维持自然节奏',
      ],
      intensityGuide: 'RPE 6–7。初学者可从 20 秒开始，每周增加 10–15 秒。出现腰部酸痛应立即停止。',
      scienceBenefits: [
        '提升脊柱稳定性，减少腰痛风险',
        '改善姿态控制与运动表现',
        '低冲击，适合各年龄段日常训练',
      ],
    ),
    WorkoutAction(
      id: 'action_squat',
      name: '深蹲跳下肢塑形',
      subtitle: '爆发力与下肢塑形',
      sets: '4组 × 12次',
      imageAsset: AppAssets.actionSquat,
      rating: 8.6,
      difficultyLabel: 'K2 初学',
      durationMinutes: 14,
      caloriesMin: 54,
      caloriesMax: 80,
      authorName: '体能教练阿杰',
      authorAvatar: AppAssets.avatars[3],
      description: '结合离心下蹲与爆发起跳，训练下肢力量与心肺耐力。注意膝盖与脚尖同向，落地轻柔缓冲，大体重者可先做普通深蹲再进阶。',
      commentCount: 329,
      practicedLabel: '6.8万',
      equipment: const ['瑜伽垫', '运动鞋'],
      tips: ['下蹲时膝盖与脚尖同向', '起跳轻盈落地轻柔', '感到不适立即停止'],
      targetMuscles: ['股四头肌', '臀大肌', '腘绳肌', '小腿三头肌'],
      biomechanics: '深蹲跳结合了离心（下蹲）、向心（起跳）与弹性反弹三个阶段。下蹲时肌肉储存弹性势能，起跳时快速伸展髋膝踝三关节，落地时通过离心收缩吸收冲击，训练下肢爆发力与反应速度。',
      commonMistakes: [
        '膝盖超过脚尖过多且内扣',
        '落地时脚跟重击地面，冲击过大',
        '下蹲深度不足，臀肌激活不充分',
      ],
      breathingGuide: [
        '下蹲时吸气，核心收紧蓄力',
        '起跳瞬间呼气，全身协调发力',
        '落地时轻柔缓冲，准备下一次',
      ],
      intensityGuide: 'RPE 7–8。每组 8–15 次，组间休息 45–90 秒。大体重者建议先做普通深蹲再进阶。',
      scienceBenefits: [
        '提升下肢爆发力与垂直跳跃能力',
        '促进骨密度，预防骨质疏松',
        '高代谢消耗，有助于减脂塑形',
      ],
    ),
  ];

  static final List<Article> articles = [
    Article(
      id: 'article_1',
      title: '为什么你每天锻炼却依然瘦不下来？',
      summary: '减脂的核心在于热量缺口，而非单纯的汗水多少。了解基础代谢率（BMR）与 NEAT（非运动消耗），让你的减脂效率翻倍……',
      content: '''
减脂的核心在于热量缺口，而非单纯的汗水多少。

很多人以为练得越多、流汗越多就瘦得越快，实际上饮食与日常活动量同样关键。基础代谢率（BMR）占每日消耗的 60%-70%，而 NEAT（非运动性热消耗）包括走路、站立、做家务等，往往被忽视。

建议：
1. 记录 3-7 天饮食，了解真实摄入。
2. 力量训练保留肌肉，避免代谢下降。
3. 保证睡眠 7-8 小时，激素平衡利于减脂。
4. 每周体重下降 0.5-1kg 为健康速度。

坚持科学方法，比盲目加练更重要。
''',
      readCount: '4.2w',
      likeCount: 892,
      category: '科学减脂',
      keyTakeaways: [
        '减脂本质是热量缺口，不是流汗多少',
        'BMR 占每日消耗 60–70%，肌肉量是关键',
        'NEAT 日常活动常被严重低估',
        '健康减脂速度：每周 0.5–1 kg',
      ],
      sections: const [
        ArticleSection(
          title: '热量平衡的基本原理',
          body: '当摄入热量 < 消耗热量时，身体动用脂肪储备供能。1 kg 脂肪约含 7700 kcal，因此每天 500 kcal 缺口约需 2 周减 1 kg。过度节食会降低代谢，反而不利长期减脂。',
        ),
        ArticleSection(
          title: 'BMR 与肌肉的关系',
          body: '基础代谢率随肌肉量增加而提升。每增加 1 kg 肌肉，每日约多消耗 13–15 kcal。力量训练在减脂期尤为重要，可防止肌肉流失导致的代谢下降（俗称「代谢适应」）。',
        ),
        ArticleSection(
          title: 'NEAT：被忽视的能量消耗',
          body: '非运动性热消耗包括站立、走动、做家务、打字等。研究表明 NEAT 个体差异可达 2000 kcal/天。增加日常活动（如走楼梯、站立办公）是可持续的减脂策略。',
        ),
        ArticleSection(
          title: '实操建议',
          body: '记录 3–7 天饮食找真实摄入；每周 3–4 次力量 + 2–3 次有氧；睡眠 7–8 小时；体重每周下降不超过 1%。',
        ),
      ],
      references: [
        'Hall KD, et al. Energy balance and obesity. Lancet. 2012.',
        'Levine JA. Non-exercise activity thermogenesis. Best Pract Res Clin Endocrinol Metab. 2002.',
      ],
    ),
    Article(
      id: 'article_2',
      title: 'HIIT 真的比慢跑更燃脂吗？',
      summary: '高强度间歇训练能在较短时间内提升心率，产生后燃效应。但并不意味着适合所有人……',
      content: '''
HIIT 能在 20-30 分钟内达到较高能量消耗，并在运动后数小时内继续消耗热量（EPOC 效应）。

适合人群：有一定运动基础、时间紧张、心肺功能良好者。
不适合：初学者、关节伤者、高血压患者需遵医嘱。

慢跑等中等强度有氧更易坚持，适合大体重或康复期。最佳策略是 HIIT 与有氧结合，每周 3-5 次，避免过度训练。
''',
      readCount: '2.8w',
      likeCount: 456,
      category: '运动生理',
      keyTakeaways: [
        'HIIT 有 EPOC 后燃效应，但总量未必超过长时间有氧',
        '适合有基础、时间紧的人群',
        '初学者应从中低强度有氧入门',
        '最佳策略：HIIT + 有氧混合安排',
      ],
      sections: const [
        ArticleSection(
          title: 'EPOC：运动后过量氧耗',
          body: '高强度运动后，身体需额外氧气来恢复肌糖原、清除乳酸、降低体温。此过程可持续 24–48 小时，额外消耗约 50–200 kcal。但单次 HIIT 总消耗未必高于 60 分钟慢跑。',
        ),
        ArticleSection(
          title: '强度与心率区间',
          body: 'HIIT 要求心率维持在最大心率的 80–95%（约 220−年龄）。中等强度有氧在 60–70%，脂肪氧化比例更高，适合长时间进行。两种模式各有优势。',
        ),
        ArticleSection(
          title: '人群适配建议',
          body: '初学者：先从快走、慢跑 30 分钟开始。有基础者：每周 2–3 次 HIIT + 2 次有氧。关节问题者：游泳、椭圆机等低冲击有氧替代。',
        ),
      ],
      references: [
        'LaForgia J, et al. Effects of exercise intensity on excess post-exercise oxygen consumption. J Sports Sci. 2006.',
      ],
    ),
    Article(
      id: 'article_3',
      title: '蛋白质摄入：增肌减脂都要够',
      summary: '每公斤体重 1.2-1.6g 蛋白质是常见建议。分配在每餐有助于饱腹与肌肉修复……',
      content: '''
蛋白质是肌肉修复与免疫的重要原料。减脂期充足蛋白可减少肌肉流失，维持代谢。

来源：鸡胸肉、鱼、蛋、豆制品、低脂奶制品。
训练后 30 分钟内补充 20-30g 蛋白效果更佳。

不必迷信蛋白粉，天然食物优先；若 busy 可备优质蛋白棒或奶昔作为补充。
''',
      readCount: '1.5w',
      likeCount: 321,
      category: '营养科学',
      keyTakeaways: [
        '减脂期建议 1.6–2.2 g/kg 蛋白质',
        '每餐 20–40 g 蛋白优化肌肉蛋白合成',
        '训练后 30 分钟内补充效果最佳',
        '天然食物优先，补剂为便利选择',
      ],
      sections: const [
        ArticleSection(
          title: '蛋白质需求量计算',
          body: '久坐人群：0.8–1.0 g/kg；规律训练：1.4–1.8 g/kg；减脂期：1.6–2.2 g/kg 以防止肌肉流失。60 kg 女性减脂期约需 96–132 g/天。',
        ),
        ArticleSection(
          title: '肌肉蛋白合成窗口',
          body: '训练后 2 小时内摄入 20–40 g 优质蛋白，可最大化肌肉修复。亮氨酸是触发合成的关键氨基酸，鸡蛋、乳清、大豆含量较高。',
        ),
        ArticleSection(
          title: '食物 vs 补剂',
          body: '天然食物提供完整氨基酸谱及微量元素。蛋白粉适合训练后不便进食时补充，不必过度依赖。素食者可通过豆类+谷物组合获取完整蛋白。',
        ),
      ],
      references: [
        'Morton RW, et al. A systematic review of protein supplementation. Br J Sports Med. 2018.',
        'Phillips SM, Van Loon LJ. Dietary protein for athletes. J Sports Sci. 2011.',
      ],
    ),
  ];

  static Course? courseById(String id) {
    for (final course in courses) {
      if (course.id == id) return course;
    }
    return null;
  }

  static Recipe? recipeById(String id) {
    for (final recipe in recipes) {
      if (recipe.id == id) return recipe;
    }
    return null;
  }

  static const DietGuide featuredDietGuide = DietGuide(
    title: '7天轻断食低脂营养餐单指南',
    subtitle: '告别水肿与饥饿，科学吃出完美马甲线。',
    badge: '低卡高蛋白',
    imageAsset: AppAssets.dietBanner,
    intro: '这是一套专为减脂期设计的 7 日轻食方案，以优质蛋白和复合碳水为核心，控制每日热量在 1200–1350 千卡，帮助你在不挨饿的前提下稳定掉秤、改善体态。',
    highlights: [
      '每日三餐结构清晰，无需复杂计算',
      '优先高蛋白，维持肌肉与饱腹感',
      '低 GI 主食，减少血糖波动与水肿',
    ],
    dailyCalories: 1250,
    proteinGrams: 85,
    durationDays: 7,
    principles: [
      '每餐保证掌心大小的优质蛋白',
      '主食替换为糙米、燕麦、藜麦等粗粮',
      '烹饪少油少盐，优先蒸、煮、烤',
      '每日饮水不少于 2000ml',
    ],
    days: [
      DietGuideDay(
        day: 1,
        theme: '启动日 · 清淡排毒',
        breakfast: '燕麦藜麦碗 + 蓝莓 + 无糖酸奶',
        lunch: '牛油果全麦鲜虾轻食碗',
        dinner: '香煎鸡胸肉配烤时蔬',
        calories: 1180,
      ),
      DietGuideDay(
        day: 2,
        theme: '蛋白日 · 增强饱腹',
        breakfast: '菠菜蘑菇蛋白烘蛋',
        lunch: '彩虹蔬菜杂粮饭',
        dinner: '香煎鸡胸肉配烤时蔬',
        calories: 1220,
      ),
      DietGuideDay(
        day: 3,
        theme: '纤维日 · 促进代谢',
        breakfast: '燕麦藜麦减脂主食碗',
        lunch: '牛油果全麦鲜虾轻食碗',
        dinner: '彩虹蔬菜杂粮饭',
        calories: 1240,
      ),
      DietGuideDay(
        day: 4,
        theme: '均衡日 · 稳定能量',
        breakfast: '菠菜蘑菇蛋白烘蛋',
        lunch: '香煎鸡胸肉配烤时蔬',
        dinner: '牛油果全麦鲜虾轻食碗',
        calories: 1260,
      ),
      DietGuideDay(
        day: 5,
        theme: '轻断食 · 控制热量',
        breakfast: '抹茶蛋白燃脂奶昔',
        lunch: '牛油果全麦鲜虾轻食碗',
        dinner: '香煎鸡胸肉配烤时蔬（减半主食）',
        calories: 1150,
      ),
      DietGuideDay(
        day: 6,
        theme: '恢复日 · 补充营养',
        breakfast: '燕麦藜麦碗 + 坚果少量',
        lunch: '彩虹蔬菜杂粮饭',
        dinner: '菠菜蘑菇蛋白烘蛋 + 时蔬',
        calories: 1280,
      ),
      DietGuideDay(
        day: 7,
        theme: '巩固日 · 养成习惯',
        breakfast: '菠菜蘑菇蛋白烘蛋',
        lunch: '牛油果全麦鲜虾轻食碗',
        dinner: '香煎鸡胸肉配烤时蔬',
        calories: 1230,
      ),
    ],
    shoppingList: [
      '鸡胸肉 / 鲜虾',
      '鸡蛋',
      '燕麦 / 藜麦 / 糙米',
      '牛油果',
      '混合时蔬',
      '蓝莓 / 香蕉',
      '无糖酸奶',
      '蛋白粉（可选）',
    ],
    tips: [
      '建议提前一晚备餐，减少决策疲劳',
      '训练日可在练后 30 分钟内补充蛋白奶昔',
      '感到饥饿时可增加无限量绿叶蔬菜',
      '周末可适当放松一餐，但避免高糖高油',
    ],
    avoidList: [
      '含糖饮料与果汁',
      '油炸与重口味外卖',
      '精制甜点与零食',
      '过量酒精',
    ],
    relatedRecipeIds: [
      'recipe_salad',
      'recipe_chicken',
      'recipe_oatmeal',
      'recipe_smoothie',
      'recipe_egg',
    ],
  );

  static FeaturedTopic? topicById(String id) {
    for (final topic in topics) {
      if (topic.id == id) return topic;
    }
    return null;
  }

  static FeaturedTopic recommendedTopicForFocus(String focusId) {
    switch (focusId) {
      case 'cardio':
        return topics.firstWhere((topic) => topic.id == 'topic_cardio');
      case 'stretch':
        return topics.firstWhere((topic) => topic.id == 'topic_stretch');
      case 'abs':
      default:
        return topics.firstWhere((topic) => topic.id == 'topic_abs');
    }
  }

  static WorkoutAction? actionById(String id) {
    for (final action in actions) {
      if (action.id == id) return action;
    }
    return null;
  }

  static Article? articleById(String id) {
    for (final article in articles) {
      if (article.id == id) return article;
    }
    return null;
  }

  static String planTitle(String planId) {
    for (final plan in fitnessPlans) {
      if (plan['id'] == planId) return plan['title']!;
    }
    return '21天减脂特训计划';
  }

  static DailyPlanDetail dailyPlanForCourse(Course course) {
    final custom = _dailyPlanMap[course.id];
    if (custom != null) return custom;

    final warmCount = (course.steps.length / 3).ceil().clamp(1, 2);
    final coolCount = 1;
    final mainCount = course.steps.length - warmCount - coolCount;

    return DailyPlanDetail(
      courseId: course.id,
      focus: course.description,
      equipment: const ['瑜伽垫', '运动水杯', '毛巾'],
      tips: const [
        '训练前 1 小时避免大量进食',
        '保持均匀呼吸，动作质量优先于速度',
        '感到头晕或关节疼痛请立即停止',
      ],
      phases: [
        PlanPhase(
          title: '热身激活',
          duration: '5 分钟',
          icon: Icons.wb_sunny_outlined,
          items: course.steps.take(warmCount).toList(),
        ),
        PlanPhase(
          title: '主训燃脂',
          duration: '${course.durationMinutes - 8} 分钟',
          icon: Icons.local_fire_department_outlined,
          items: course.steps.skip(warmCount).take(mainCount).toList(),
        ),
        PlanPhase(
          title: '拉伸恢复',
          duration: '5 分钟',
          icon: Icons.self_improvement_outlined,
          items: course.steps.skip(warmCount + mainCount).toList(),
        ),
      ],
      afterWorkoutTip: '训练后 30 分钟内补充优质蛋白，有助于肌肉恢复与代谢提升。',
      targetCalories: course.calories,
      targetMinutes: course.durationMinutes,
      intensity: course.difficulty,
      heartRateZone: '目标心率 60%–75% 最大心率',
      mealSuggestion: '训练前：香蕉或全麦面包；训练后：鸡胸肉沙拉或蛋白奶昔。',
    );
  }

  static final Map<String, DailyPlanDetail> _dailyPlanMap = {
    'course_hiit': DailyPlanDetail(
      courseId: 'course_hiit',
      focus: '通过高强度间歇训练快速提升心率，最大化今日燃脂效率。',
      equipment: ['瑜伽垫', '运动水杯', '心率手环（可选）'],
      tips: [
        '今日为计划第 8 天，身体适应性已提升，可适当加快节奏',
        '组间休息不超过 20 秒，保持心率在燃脂区间',
        '训练结束后进行 3 分钟深呼吸放松',
      ],
      phases: [
        const PlanPhase(
          title: '热身激活',
          duration: '5 分钟',
          icon: Icons.wb_sunny_outlined,
          items: [
            '关节环绕：颈、肩、髋、膝各 30 秒',
            '原地慢跑 2 分钟，逐渐提升心率',
            '动态拉伸：弓步转体、摆臂各 1 分钟',
          ],
        ),
        const PlanPhase(
          title: 'HIIT 主训',
          duration: '17 分钟',
          icon: Icons.local_fire_department_outlined,
          items: [
            '波比跳 45 秒 → 休息 15 秒 × 4 组',
            '高抬腿 40 秒 → 休息 20 秒 × 4 组',
            '登山跑 45 秒 → 休息 15 秒 × 4 组',
            '开合跳 40 秒 → 休息 20 秒 × 3 组',
          ],
        ),
        const PlanPhase(
          title: '拉伸恢复',
          duration: '5 分钟',
          icon: Icons.self_improvement_outlined,
          items: [
            '大腿前侧、后侧拉伸各 45 秒',
            '肩部与背部舒展 1 分钟',
            '腹式呼吸放松 1 分钟',
          ],
        ),
      ],
      afterWorkoutTip: '今日消耗目标 280 千卡，建议搭配高蛋白低脂餐，避免高糖饮料。',
      targetCalories: 280,
      targetMinutes: 25,
      intensity: '中等偏高',
      heartRateZone: '燃脂区间 130–155 bpm',
      mealSuggestion: '练前 1 小时：半根香蕉 + 黑咖啡；练后：牛油果虾仁轻食碗。',
    ),
    'course_jump': DailyPlanDetail(
      courseId: 'course_jump',
      focus: '低冲击全身燃脂，保护膝盖的同时维持心率，适合晚间或公寓居家训练。',
      equipment: ['瑜伽垫', '运动水杯', '防滑袜'],
      tips: [
        '全程保持脚掌着地，避免跳跃冲击',
        '动作幅度由小到大，前 5 分钟以激活为主',
        '若感到膝盖不适，可缩小弓步幅度或改为半蹲',
      ],
      phases: [
        const PlanPhase(
          title: '关节激活',
          duration: '3 分钟',
          icon: Icons.wb_sunny_outlined,
          items: [
            '踝关节绕环、膝关节绕环各 30 秒',
            '原地踏步配合摆臂 2 分钟',
            '髋部开合 30 秒',
          ],
        ),
        const PlanPhase(
          title: '无跳跃燃脂',
          duration: '10 分钟',
          icon: Icons.local_fire_department_outlined,
          items: [
            '深蹲触地 40 秒 → 休息 20 秒 × 3 组',
            '侧弓步交替 40 秒 → 休息 20 秒 × 3 组',
            '平板支撑交替触肩 30 秒 → 休息 15 秒 × 4 组',
          ],
        ),
        const PlanPhase(
          title: '拉伸放松',
          duration: '2 分钟',
          icon: Icons.self_improvement_outlined,
          items: [
            '大腿前后侧拉伸各 30 秒',
            '肩部环绕与深呼吸 1 分钟',
          ],
        ),
      ],
      afterWorkoutTip: '今日为轻量燃脂日，练后补充少量碳水与蛋白质即可，不必过量进食。',
      targetCalories: 140,
      targetMinutes: 15,
      intensity: '低至中等',
      heartRateZone: '有氧区间 110–135 bpm',
      mealSuggestion: '练前：一小把坚果；练后：希腊酸奶配蓝莓。',
    ),
    'course_abs': DailyPlanDetail(
      courseId: 'course_abs',
      focus: '强化腹直肌与腹斜肌，提升核心稳定性，为今日训练打好腰腹基础。',
      equipment: ['瑜伽垫', '计时器'],
      tips: [
        '收紧核心，避免用颈部发力带动卷腹',
        '组间休息 30 秒，保持腹肌持续紧张感',
        '若腰部不适，可减少举腿幅度',
      ],
      phases: [
        const PlanPhase(
          title: '核心唤醒',
          duration: '3 分钟',
          icon: Icons.wb_sunny_outlined,
          items: [
            '死虫式 10 次',
            '猫牛式 1 分钟',
            '腹式呼吸 1 分钟',
          ],
        ),
        const PlanPhase(
          title: '腹肌主训',
          duration: '12 分钟',
          icon: Icons.local_fire_department_outlined,
          items: [
            '卷腹 20 次 × 3 组',
            '俄罗斯转体 30 次 × 3 组',
            '仰卧举腿 15 次 × 3 组',
            '平板支撑 60 秒 × 3 组',
          ],
        ),
        const PlanPhase(
          title: '恢复拉伸',
          duration: '3 分钟',
          icon: Icons.self_improvement_outlined,
          items: [
            '眼镜蛇式拉伸 45 秒',
            '婴儿式放松 1 分钟',
            '侧腰拉伸左右各 30 秒',
          ],
        ),
      ],
      afterWorkoutTip: '核心训练后避免立即进行大重量深蹲，给腰腹 10 分钟恢复时间。',
      targetCalories: 160,
      targetMinutes: 18,
      intensity: '中等',
      heartRateZone: '力量耐力 100–125 bpm',
      mealSuggestion: '练后推荐：水煮蛋 + 蔬菜沙拉，补充优质蛋白。',
    ),
  };
}
