import '../models/ai_response.dart';
import '../models/consultation.dart';
import '../models/law_firm.dart';
import '../models/lawyer.dart';
import '../models/lawyer_review.dart';
import '../models/legal_book.dart';
import '../models/legal_document.dart';
import '../models/legal_guidance.dart';
import '../models/practice_area.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../models/wallet.dart';

class MockDataService {
  static const Map<String, dynamic> schema = <String, dynamic>{
    'User': <String, String>{
      'id': 'String',
      'name': 'String',
      'email': 'String',
      'phone': 'String',
      'profilePhoto': 'String',
      'walletBalance': 'double',
      'consultationsCompleted': 'int',
      'savedLawyers': 'List<String>',
      'uploadedDocuments': 'List<String>',
      'createdAt': 'DateTime',
    },
    'Wallet': <String, String>{
      'userId': 'String',
      'balance': 'double',
      'transactions': 'List<Transaction>',
    },
    'Transaction': <String, String>{
      'id': 'String',
      'userId': 'String',
      'type': 'credit | debit',
      'amount': 'double',
      'description': 'String',
      'consultationId': 'String?',
      'createdAt': 'DateTime',
    },
    'Firm': <String, String>{
      'id': 'String',
      'name': 'String',
      'logo': 'String',
      'description': 'String',
      'city': 'String',
      'address': 'String',
      'foundedYear': 'int',
      'totalLawyers': 'int',
      'practiceAreas': 'List<String>',
    },
    'Lawyer': <String, String>{
      'id': 'String',
      'name': 'String',
      'profilePhoto': 'String',
      'firmId': 'String',
      'specialization': 'String',
      'experienceYears': 'int',
      'courtsPracticed': 'List<String>',
      'languages': 'List<String>',
      'rating': 'double',
      'reviewCount': 'int',
      'consultationFeeChat': 'double',
      'consultationFeeVoice': 'double',
      'consultationFeeVideo': 'double',
      'availableNow': 'bool',
      'bio': 'String',
    },
    'Review': <String, String>{
      'id': 'String',
      'lawyerId': 'String',
      'userId': 'String',
      'rating': 'double',
      'comment': 'String',
      'createdAt': 'DateTime',
    },
    'Consultation': <String, String>{
      'id': 'String',
      'userId': 'String',
      'lawyerId': 'String',
      'type': 'chat | voice | video',
      'durationMinutes': 'int',
      'cost': 'double',
      'status': 'completed | active | cancelled',
      'createdAt': 'DateTime',
    },
    'LegalGuidance': <String, String>{
      'id': 'String',
      'problemTitle': 'String',
      'explanation': 'String',
      'applicableLaws': 'List<String>',
      'pathwaySteps': 'List<String>',
      'requiredDocuments': 'List<String>',
      'recommendedLawyerType': 'String',
    },
    'LegalBook': <String, String>{
      'id': 'String',
      'title': 'String',
      'category': 'String',
      'author': 'String',
      'year': 'int',
      'description': 'String',
      'chapters': 'List<String>',
    },
    'PracticeArea': <String, String>{
      'id': 'String',
      'name': 'String',
      'description': 'String',
    },
    'Document': <String, String>{
      'id': 'String',
      'userId': 'String',
      'name': 'String',
      'type': 'String',
      'uploadDate': 'DateTime',
      'relatedConsultationId': 'String?',
    },
    'relationships': <String, String>{
      'User -> Consultations': 'Consultation.userId',
      'Consultation -> Lawyer': 'Consultation.lawyerId',
      'Lawyer -> Firm': 'Lawyer.firmId',
      'Lawyer -> Reviews': 'Review.lawyerId',
      'Firm -> Lawyers': 'Lawyer.firmId',
      'User -> Wallet': 'Wallet.userId',
      'User -> Documents': 'Document.userId',
    },
  };

  static final List<_UserSeed> _userSeeds = <_UserSeed>[
    _UserSeed(
      id: 'u01',
      name: 'Arjun Mehta',
      email: 'arjun.mehta@dharamraksha.app',
      phone: '+91 98765 43210',
      profilePhoto: 'https://randomuser.me/api/portraits/men/32.jpg',
      isVerified: true,
      createdAt: DateTime(2024, 3, 2),
    ),
    _UserSeed(
      id: 'u02',
      name: 'Priya Nair',
      email: 'priya.nair@dharamraksha.app',
      phone: '+91 98111 22004',
      profilePhoto: 'https://randomuser.me/api/portraits/women/11.jpg',
      isVerified: true,
      createdAt: DateTime(2024, 2, 18),
    ),
    _UserSeed(
      id: 'u03',
      name: 'Rohan Gupta',
      email: 'rohan.gupta@dharamraksha.app',
      phone: '+91 99004 22671',
      profilePhoto: 'https://randomuser.me/api/portraits/men/45.jpg',
      isVerified: false,
      createdAt: DateTime(2024, 4, 5),
    ),
    _UserSeed(
      id: 'u04',
      name: 'Sneha Kapoor',
      email: 'sneha.kapoor@dharamraksha.app',
      phone: '+91 98900 11872',
      profilePhoto: 'https://randomuser.me/api/portraits/women/65.jpg',
      isVerified: true,
      createdAt: DateTime(2024, 1, 12),
    ),
    _UserSeed(
      id: 'u05',
      name: 'Vivek Reddy',
      email: 'vivek.reddy@dharamraksha.app',
      phone: '+91 98222 44901',
      profilePhoto: 'https://randomuser.me/api/portraits/men/74.jpg',
      isVerified: true,
      createdAt: DateTime(2024, 5, 28),
    ),
    _UserSeed(
      id: 'u06',
      name: 'Ananya Das',
      email: 'ananya.das@dharamraksha.app',
      phone: '+91 98670 88190',
      profilePhoto: 'https://randomuser.me/api/portraits/women/34.jpg',
      isVerified: true,
      createdAt: DateTime(2024, 6, 8),
    ),
    _UserSeed(
      id: 'u07',
      name: 'Kunal Verma',
      email: 'kunal.verma@dharamraksha.app',
      phone: '+91 99888 16355',
      profilePhoto: 'https://randomuser.me/api/portraits/men/28.jpg',
      isVerified: false,
      createdAt: DateTime(2024, 7, 2),
    ),
    _UserSeed(
      id: 'u08',
      name: 'Meera Joshi',
      email: 'meera.joshi@dharamraksha.app',
      phone: '+91 97111 77410',
      profilePhoto: 'https://randomuser.me/api/portraits/women/22.jpg',
      isVerified: true,
      createdAt: DateTime(2024, 8, 14),
    ),
    _UserSeed(
      id: 'u09',
      name: 'Siddharth Rao',
      email: 'siddharth.rao@dharamraksha.app',
      phone: '+91 99555 33090',
      profilePhoto: 'https://randomuser.me/api/portraits/men/83.jpg',
      isVerified: true,
      createdAt: DateTime(2024, 9, 21),
    ),
    _UserSeed(
      id: 'u10',
      name: 'Kavita Singh',
      email: 'kavita.singh@dharamraksha.app',
      phone: '+91 97777 20488',
      profilePhoto: 'https://randomuser.me/api/portraits/women/80.jpg',
      isVerified: true,
      createdAt: DateTime(2024, 10, 6),
    ),
  ];

  static final List<PracticeArea> practiceAreas = <PracticeArea>[
    const PracticeArea(
      id: 'pa01',
      name: 'Criminal Law',
      description:
          'Representation for FIR, bail, trial strategy, and criminal appeals.',
    ),
    const PracticeArea(
      id: 'pa02',
      name: 'Family Law',
      description:
          'Divorce, maintenance, child custody, domestic violence, and settlements.',
    ),
    const PracticeArea(
      id: 'pa03',
      name: 'Corporate Law',
      description:
          'Company compliance, contracts, due diligence, and governance advisory.',
    ),
    const PracticeArea(
      id: 'pa04',
      name: 'Labour Law',
      description:
          'Wage recovery, termination disputes, workplace rights, and compliance.',
    ),
    const PracticeArea(
      id: 'pa05',
      name: 'Civil Litigation',
      description:
          'Civil suits, injunctions, recoveries, and contractual disputes.',
    ),
    const PracticeArea(
      id: 'pa06',
      name: 'Property Law',
      description:
          'Title verification, tenancy disputes, partition, and possession issues.',
    ),
    const PracticeArea(
      id: 'pa07',
      name: 'Consumer Law',
      description:
          'Complaints for defective products, service deficiency, and compensation.',
    ),
    const PracticeArea(
      id: 'pa08',
      name: 'Cyber Law',
      description:
          'Online fraud, digital evidence, data breach, and cyber complaint actions.',
    ),
    const PracticeArea(
      id: 'pa09',
      name: 'Tax Law',
      description:
          'GST, direct tax notices, assessments, and appellate representation.',
    ),
    const PracticeArea(
      id: 'pa10',
      name: 'Startup Compliance',
      description:
          'Incorporation, founder agreements, ESOPs, IP protection, and funding docs.',
    ),
  ];

  static final List<LawFirm> lawFirms = <LawFirm>[
    const LawFirm(
      id: 'f01',
      name: 'Alpha Legal Solutions',
      logo: 'https://dummyimage.com/160x160/0f172a/ffffff.png&text=ALS',
      description:
          'Alpha Legal Solutions advises professionals and SMEs on labour, corporate, and commercial matters with a litigation-ready approach.',
      city: 'New Delhi',
      address: 'A-42, Barakhamba Road, Connaught Place, New Delhi',
      foundedYear: 2008,
      totalLawyers: 6,
      practiceAreas: <String>[
        'Corporate Law',
        'Labour Law',
        'Civil Litigation',
      ],
    ),
    const LawFirm(
      id: 'f02',
      name: 'Veritas Law Chambers',
      logo: 'https://dummyimage.com/160x160/1d4ed8/ffffff.png&text=VLC',
      description:
          'Veritas Law Chambers is known for trial strategy, cyber investigations, and white-collar representation in high-stakes disputes.',
      city: 'Mumbai',
      address: 'Level 9, Nariman Point, Mumbai, Maharashtra',
      foundedYear: 2011,
      totalLawyers: 6,
      practiceAreas: <String>[
        'Criminal Law',
        'Cyber Law',
        'Consumer Law',
      ],
    ),
    const LawFirm(
      id: 'f03',
      name: 'LexBridge Associates',
      logo: 'https://dummyimage.com/160x160/047857/ffffff.png&text=LBA',
      description:
          'LexBridge Associates provides practical counsel on property, family, and civil recovery issues with a strong mediation wing.',
      city: 'Bengaluru',
      address: '12th Main Road, Indiranagar, Bengaluru, Karnataka',
      foundedYear: 2013,
      totalLawyers: 6,
      practiceAreas: <String>[
        'Property Law',
        'Family Law',
        'Civil Litigation',
      ],
    ),
    const LawFirm(
      id: 'f04',
      name: 'Nyaya Frontier Partners',
      logo: 'https://dummyimage.com/160x160/b45309/ffffff.png&text=NFP',
      description:
          'Nyaya Frontier Partners combines litigation and policy-grade drafting for employment, tax, and commercial risk matters.',
      city: 'Hyderabad',
      address: 'Road No. 36, Jubilee Hills, Hyderabad, Telangana',
      foundedYear: 2010,
      totalLawyers: 6,
      practiceAreas: <String>[
        'Labour Law',
        'Tax Law',
        'Corporate Law',
      ],
    ),
    const LawFirm(
      id: 'f05',
      name: 'JurisPoint Counsel',
      logo: 'https://dummyimage.com/160x160/7c2d12/ffffff.png&text=JPC',
      description:
          'JurisPoint Counsel supports founders and individuals with startup compliance, contracts, and civil dispute resolution.',
      city: 'Pune',
      address: 'Senapati Bapat Road, Shivajinagar, Pune, Maharashtra',
      foundedYear: 2016,
      totalLawyers: 6,
      practiceAreas: <String>[
        'Startup Compliance',
        'Consumer Law',
        'Civil Litigation',
      ],
    ),
  ];

  static final List<LawyerReview> lawyerReviews = _buildLawyerReviews();
  static final List<Lawyer> lawyers = _buildLawyers();
  static final List<Consultation> consultations = _buildConsultations();
  static final List<Transaction> walletTransactions =
      _buildWalletTransactions();
  static final List<Wallet> wallets = _buildWallets();
  static final List<LegalDocument> documents = _buildDocuments();
  static final List<AppUser> users = _buildUsers();
  static final List<LegalGuidance> legalGuidances = _buildLegalGuidances();
  static final List<LegalBook> legalBooks = _buildLegalBooks();

  static final List<String> quickIssues = legalGuidances
      .take(5)
      .map((guidance) => guidance.problemTitle)
      .toList(growable: false);

  static Map<String, dynamic> get dataCounts => <String, int>{
        'users': users.length,
        'firms': lawFirms.length,
        'lawyers': lawyers.length,
        'consultations': consultations.length,
        'reviews': lawyerReviews.length,
        'walletTransactions': walletTransactions.length,
        'legalGuidanceProblems': legalGuidances.length,
        'legalBooks': legalBooks.length,
        'practiceAreas': practiceAreas.length,
        'documents': documents.length,
      };

  static Map<String, dynamic> get mockDataBundle => <String, dynamic>{
        'schema': schema,
        'counts': dataCounts,
        'users': users.map((user) => user.toJson()).toList(growable: false),
        'wallets':
            wallets.map((wallet) => wallet.toJson()).toList(growable: false),
        'firms': lawFirms.map((firm) => firm.toJson()).toList(growable: false),
        'lawyers':
            lawyers.map((lawyer) => lawyer.toJson()).toList(growable: false),
        'reviews': lawyerReviews
            .map((review) => review.toJson())
            .toList(growable: false),
        'consultations': consultations
            .map((consultation) => consultation.toJson())
            .toList(growable: false),
        'legalGuidance': legalGuidances
            .map((guidance) => guidance.toJson())
            .toList(growable: false),
        'legalBooks':
            legalBooks.map((book) => book.toJson()).toList(growable: false),
        'practiceAreas': practiceAreas
            .map((practiceArea) => practiceArea.toJson())
            .toList(growable: false),
        'documents': documents
            .map((document) => document.toJson())
            .toList(growable: false),
      };

  static List<String> get allPracticeAreas {
    final areas = <String>{
      for (final lawyer in lawyers) ...lawyer.practiceAreas
    };
    final sorted = areas.toList()..sort();
    return sorted;
  }

  static List<String> get allLocations {
    final locations = <String>{for (final lawyer in lawyers) lawyer.location};
    final sorted = locations.toList()..sort();
    return sorted;
  }

  static List<String> get allLanguages {
    final languages = <String>{
      for (final lawyer in lawyers) ...lawyer.languages
    };
    final sorted = languages.toList()..sort();
    return sorted;
  }

  static LawFirm? getFirmById(String firmId) {
    for (final firm in lawFirms) {
      if (firm.id == firmId) {
        return firm;
      }
    }
    return null;
  }

  static Lawyer? getLawyerById(String lawyerId) {
    for (final lawyer in lawyers) {
      if (lawyer.id == lawyerId) {
        return lawyer;
      }
    }
    return null;
  }

  static AppUser? getUserById(String userId) {
    for (final user in users) {
      if (user.id == userId) {
        return user;
      }
    }
    return null;
  }

  static Wallet? getWalletByUser(String userId) {
    for (final wallet in wallets) {
      if (wallet.userId == userId) {
        return wallet;
      }
    }
    return null;
  }

  static List<Lawyer> lawyersByFirm(String firmId) {
    return lawyers.where((lawyer) => lawyer.firmId == firmId).toList();
  }

  static List<LawyerReview> reviewsByLawyer(String lawyerId) {
    return lawyerReviews
        .where((review) => review.lawyerId == lawyerId)
        .toList();
  }

  static List<Consultation> consultationsByUser(String userId) {
    return consultations
        .where((consultation) => consultation.userId == userId)
        .toList();
  }

  static List<LegalDocument> documentsByUser(String userId) {
    return documents.where((document) => document.userId == userId).toList();
  }

  static AIResponse buildGuidance(String problem) {
    final query = problem.trim().toLowerCase();
    if (query.isEmpty) {
      return legalGuidances.first.toAIResponse();
    }

    LegalGuidance? bestMatch;
    var bestScore = -1;

    for (final guidance in legalGuidances) {
      var score = 0;
      for (final keyword in guidance.keywords) {
        if (query.contains(keyword.toLowerCase())) {
          score += 2;
        }
      }
      for (final word in guidance.problemTitle.toLowerCase().split(' ')) {
        if (word.length > 3 && query.contains(word)) {
          score += 1;
        }
      }
      if (score > bestScore) {
        bestScore = score;
        bestMatch = guidance;
      }
    }

    final selected = bestMatch ?? legalGuidances.first;
    final response = selected.toAIResponse();
    return AIResponse(
      problemUnderstanding: response.problemUnderstanding,
      applicableLaws: response.applicableLaws,
      legalPathwaySteps: response.legalPathwaySteps,
      requiredDocuments: <String>[
        ...response.requiredDocuments,
        'Issue summary: "$problem"',
      ],
      recommendedLawyerType: response.recommendedLawyerType,
    );
  }

  static List<LawyerReview> _buildLawyerReviews() {
    final comments = <String>[
      'Very clear legal strategy and realistic timeline.',
      'Explained process documents step by step and stayed responsive.',
      'Helped me draft notice quickly and avoid procedural mistakes.',
      'Strong subject knowledge and practical court-focused advice.',
      'Transparent about costs, risks, and likely outcomes.',
      'Good communication and timely follow-up after consultation.',
      'Guided me on evidence preparation before filing the complaint.',
      'Professional, empathetic, and precise with legal drafting.',
      'Suggested settlement route first, then litigation fallback.',
      'Helpful for urgent consultation and immediate next steps.',
    ];
    final now = DateTime.now();

    return List<LawyerReview>.generate(100, (index) {
      final user = _userSeeds[index % _userSeeds.length];
      final lawyerId = _lawyerId(((index * 7) % 30) + 1);
      final rawRating = 3.9 + (((index * 3) % 12) / 10);
      final rating = rawRating > 5 ? 5.0 : rawRating;
      return LawyerReview(
        id: 'r${(index + 1).toString().padLeft(3, '0')}',
        lawyerId: lawyerId,
        userId: user.id,
        reviewerName: _reviewerDisplayName(user.name),
        rating: double.parse(rating.toStringAsFixed(1)),
        comment: comments[index % comments.length],
        createdAt: now.subtract(Duration(days: 2 + ((index * 4) % 300))),
      );
    });
  }

  static List<Lawyer> _buildLawyers() {
    final names = <String>[
      'Adv. Rahul Sharma',
      'Adv. Neha Malhotra',
      'Adv. Arjun Menon',
      'Adv. Farah Khan',
      'Adv. Kavya Iyer',
      'Adv. Sandeep Kulkarni',
      'Adv. Nidhi Bansal',
      'Adv. Aman Srivastava',
      'Adv. Ritu Chawla',
      'Adv. Harsh Vardhan',
      'Adv. Priyanka Sen',
      'Adv. Manav Deshpande',
      'Adv. Zoya Ali',
      'Adv. Akash Khanna',
      'Adv. Tania Bedi',
      'Adv. Rohit Sinha',
      'Adv. Ishita Ghosh',
      'Adv. Dev Patel',
      'Adv. Shruti Rao',
      'Adv. Tarun Arora',
      'Adv. Pooja Tiwari',
      'Adv. Nikhil Jain',
      'Adv. Saloni Bhatt',
      'Adv. Vishal Nair',
      'Adv. Deepa Menon',
      'Adv. Yash Thakur',
      'Adv. Alina Roy',
      'Adv. Mohit Arora',
      'Adv. Rhea Mukherjee',
      'Adv. Karan Bhatia',
    ];

    final specializations = <String>[
      'Criminal Law',
      'Family Law',
      'Corporate Law',
      'Labour Law',
      'Civil Litigation',
      'Property Law',
      'Consumer Law',
      'Cyber Law',
      'Tax Law',
      'Startup Compliance',
    ];

    final reviewsByLawyer = <String, List<LawyerReview>>{};
    for (final review in lawyerReviews) {
      reviewsByLawyer.putIfAbsent(review.lawyerId, () => <LawyerReview>[]);
      reviewsByLawyer[review.lawyerId]!.add(review);
    }

    return List<Lawyer>.generate(names.length, (index) {
      final id = _lawyerId(index + 1);
      final firm = lawFirms[index ~/ 6];
      final specialization = specializations[index % specializations.length];
      final secondaryArea =
          specializations[(index + 3) % specializations.length];
      final reviews = reviewsByLawyer[id] ?? <LawyerReview>[];
      reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final chatFee = 25 + ((index * 3) % 41);
      final voiceFee = (chatFee * 1.25).roundToDouble();
      final videoFee = (chatFee * 1.55).roundToDouble();
      final cityCourts = _cityCourts(firm.city);
      final cityLanguages = _cityLanguages(firm.city);
      final courts = <String>[
        cityCourts[index % cityCourts.length],
        cityCourts[(index + 1) % cityCourts.length],
      ];
      final languages = <String>[
        cityLanguages[0],
        cityLanguages[1],
        if (cityLanguages.length > 2 &&
            index % 2 == 0 &&
            cityLanguages[2] != cityLanguages[1])
          cityLanguages[2],
      ];

      return Lawyer(
        id: id,
        name: names[index],
        profilePhoto:
            'https://randomuser.me/api/portraits/${index.isEven ? 'men' : 'women'}/${(index + 24) % 90}.jpg',
        firmId: firm.id,
        specialization: specialization,
        practiceAreas: <String>[specialization, secondaryArea],
        experienceYears: 4 + ((index * 2) % 19),
        courtsPracticed: courts,
        languages: languages,
        rating: _averageRating(reviews),
        reviewCount: reviews.length,
        consultationFeeChat: chatFee.toDouble(),
        consultationFeeVoice: voiceFee,
        consultationFeeVideo: videoFee,
        availableNow: index % 4 != 0,
        location: firm.city,
        averageResponseMinutes: 4 + (index % 11),
        bio:
            '${names[index]} handles $specialization matters with a focus on practical strategy, complete documentation, and forum-ready preparation for clients in ${firm.city}.',
        recommendedLawyerType: '$specialization Lawyer',
        expertise: _expertiseFor(specialization),
        reviews: reviews,
        status: index % 5 == 0 ? 'Busy' : (index % 4 == 0 ? 'Offline' : 'Online'),
        isFeatured: index % 7 == 0,
        hasFreeFirstMessage: index % 3 == 0,
        introVideoUrl: index % 6 == 0 ? 'https://example.com/video$index.mp4' : null,
      );
    });
  }

  static List<Consultation> _buildConsultations() {
    const consultationTypes = <String>['chat', 'voice', 'video'];
    final now = DateTime.now();

    return List<Consultation>.generate(40, (index) {
      final user = _userSeeds[index % _userSeeds.length];
      final lawyer = lawyers[(index * 5) % lawyers.length];
      final type = consultationTypes[index % consultationTypes.length];
      final durationMinutes = 12 + ((index * 3) % 44);
      final feePerMinute = type == 'chat'
          ? lawyer.consultationFeeChat
          : type == 'voice'
              ? lawyer.consultationFeeVoice
              : lawyer.consultationFeeVideo;
      final status = index < 28
          ? 'completed'
          : index < 36
              ? 'active'
              : 'cancelled';
      final cost = status == 'cancelled'
          ? 0
          : status == 'active'
              ? durationMinutes * feePerMinute * 0.65
              : durationMinutes * feePerMinute;

      return Consultation(
        id: 'c${(index + 1).toString().padLeft(3, '0')}',
        userId: user.id,
        lawyerId: lawyer.id,
        type: type,
        durationMinutes: durationMinutes,
        cost: double.parse(cost.toStringAsFixed(0)),
        status: status,
        createdAt: now.subtract(Duration(days: index * 2 + (index % 5))),
      );
    });
  }

  static List<Transaction> _buildWalletTransactions() {
    final transactions = <Transaction>[];
    var id = 1;
    final now = DateTime.now();

    for (var i = 0; i < _userSeeds.length; i++) {
      transactions.add(
        Transaction(
          id: 't${id.toString().padLeft(3, '0')}',
          userId: _userSeeds[i].id,
          type: TransactionType.credit,
          amount: (3000 + (i * 600)).toDouble(),
          title: 'Wallet Recharge',
          description: 'Wallet recharge via UPI',
          category: 'Top-up',
          dateTime: now.subtract(Duration(days: 110 - i)),
        ),
      );
      id += 1;
    }

    for (var i = 0; i < 32; i++) {
      final consultation = consultations[i];
      final lawyer = getLawyerById(consultation.lawyerId);
      final amount = consultation.cost > 0
          ? consultation.cost
          : (lawyer?.consultationFeeChat ?? 40) * 10;
      transactions.add(
        Transaction(
          id: 't${id.toString().padLeft(3, '0')}',
          userId: consultation.userId,
          type: TransactionType.debit,
          amount: double.parse(amount.toStringAsFixed(0)),
          title: 'Consultation Payment',
          description:
              '${consultation.type.toUpperCase()} consultation payment - ${lawyer?.name ?? 'Assigned lawyer'}',
          category: 'Consultation',
          consultationId: consultation.id,
          dateTime: consultation.createdAt.add(const Duration(minutes: 5)),
        ),
      );
      id += 1;
    }

    for (var i = 0; i < 8; i++) {
      final consultation = consultations[32 + i];
      final reference = consultations[(i * 3) % 28];
      final refundAmount = (reference.cost * 0.4).clamp(180, 1800).toDouble();
      transactions.add(
        Transaction(
          id: 't${id.toString().padLeft(3, '0')}',
          userId: consultation.userId,
          type: TransactionType.credit,
          amount: double.parse(refundAmount.toStringAsFixed(0)),
          title: 'Transaction Refund',
          description: 'Refund for cancelled consultation',
          category: 'Refund',
          consultationId: consultation.id,
          dateTime: consultation.createdAt.add(const Duration(hours: 6)),
        ),
      );
      id += 1;
    }

    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }

  static List<Wallet> _buildWallets() {
    final grouped = <String, List<Transaction>>{};
    for (final transaction in walletTransactions) {
      grouped.putIfAbsent(transaction.userId, () => <Transaction>[]);
      grouped[transaction.userId]!.add(transaction);
    }

    return _userSeeds.map((seed) {
      final transactions = grouped[seed.id] ?? <Transaction>[];
      transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final credits = transactions
          .where((tx) => tx.type == TransactionType.credit)
          .fold<double>(0, (sum, tx) => sum + tx.amount);
      final debits = transactions
          .where((tx) => tx.type == TransactionType.debit)
          .fold<double>(0, (sum, tx) => sum + tx.amount);
      final balance = credits - debits;
      return Wallet(
        userId: seed.id,
        balance: double.parse(balance.toStringAsFixed(2)),
        transactions: transactions,
      );
    }).toList(growable: false);
  }

  static List<LegalDocument> _buildDocuments() {
    final names = <String>[
      'Employment Contract - Signed Copy',
      'Rental Agreement - Registered',
      'Legal Notice - Draft Copy',
      'Salary Slips - Last 6 Months',
      'Bank Statement - Relevant Entries',
      'Invoice and Payment Ledger',
      'Consumer Purchase Invoice',
      'Medical Report and Bills',
      'Police Complaint Acknowledgement',
      'Property Ownership Papers',
    ];

    final documents = List<LegalDocument>.generate(30, (index) {
      final userId = _userSeeds[index % _userSeeds.length].id;
      final consultation = consultations[(index * 2) % consultations.length];
      final relatedConsultationId =
          consultation.userId == userId ? consultation.id : null;
      return LegalDocument(
        id: 'd${(index + 1).toString().padLeft(3, '0')}',
        userId: userId,
        name: names[index % names.length],
        type: names[index % names.length].split(' - ').first,
        uploadDate:
            consultation.createdAt.subtract(Duration(days: 1 + (index % 6))),
        relatedConsultationId: relatedConsultationId,
      );
    });

    documents.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
    return documents;
  }

  static List<AppUser> _buildUsers() {
    final documentsByUser = <String, List<LegalDocument>>{};
    for (final document in documents) {
      documentsByUser.putIfAbsent(document.userId, () => <LegalDocument>[]);
      documentsByUser[document.userId]!.add(document);
    }

    final completedConsultationsByUser = <String, int>{};
    for (final consultation in consultations) {
      if (consultation.status == 'completed') {
        completedConsultationsByUser[consultation.userId] =
            (completedConsultationsByUser[consultation.userId] ?? 0) + 1;
      }
    }

    final walletByUser = <String, Wallet>{
      for (final wallet in wallets) wallet.userId: wallet,
    };

    final users = <AppUser>[];
    for (var i = 0; i < _userSeeds.length; i++) {
      final seed = _userSeeds[i];
      final uploadedDocuments = (documentsByUser[seed.id] ?? <LegalDocument>[])
          .take(4)
          .map((document) => document.id)
          .toList(growable: false);
      final savedLawyers = <String>[
        _lawyerId(((i * 3) % 30) + 1),
        _lawyerId(((i * 3 + 4) % 30) + 1),
      ];
      users.add(
        AppUser(
          id: seed.id,
          name: seed.name,
          email: seed.email,
          phone: seed.phone,
          profilePhoto: seed.profilePhoto,
          walletBalance: walletByUser[seed.id]?.balance ?? 0,
          isVerified: seed.isVerified,
          consultationsCompleted: completedConsultationsByUser[seed.id] ?? 0,
          savedLawyers: savedLawyers,
          uploadedDocuments: uploadedDocuments,
          createdAt: seed.createdAt,
        ),
      );
    }
    return users;
  }

  static List<LegalGuidance> _buildLegalGuidances() {
    final entries = <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'lg01',
        'title': 'Salary not paid by employer',
        'explanation':
            'Unpaid wages can be recovered through labour complaint and adjudication if notice is ignored.',
        'laws': <String>[
          'Payment of Wages Act, 1936',
          'Code on Wages, 2019',
          'Industrial Disputes Act, 1947',
        ],
        'steps': <String>[
          'Step 1: Send a written salary demand and legal notice.',
          'Step 2: File complaint before Labour Commissioner.',
          'Step 3: Initiate Labour Court proceedings for recovery.',
        ],
        'docs': <String>[
          'Employment contract',
          'Salary slips and bank records',
          'Communication with employer',
        ],
        'type': 'Labour Lawyer',
        'keywords': <String>['salary', 'wage', 'employer', 'unpaid'],
      },
      <String, dynamic>{
        'id': 'lg02',
        'title': 'Wrongful termination without notice',
        'explanation':
            'Illegal termination disputes are resolved through notice, conciliation, and labour forum action.',
        'laws': <String>[
          'Industrial Disputes Act, 1947',
          'Shops and Establishments Act',
          'Indian Contract Act, 1872',
        ],
        'steps': <String>[
          'Step 1: Collect termination letter and policy records.',
          'Step 2: Challenge termination through legal notice.',
          'Step 3: File labour dispute for reinstatement/compensation.',
        ],
        'docs': <String>[
          'Termination communication',
          'Employment terms',
          'Salary and attendance history',
        ],
        'type': 'Labour Lawyer',
        'keywords': <String>['termination', 'fired', 'dismissal', 'notice'],
      },
      <String, dynamic>{
        'id': 'lg03',
        'title': 'Tenant refusing to vacate',
        'explanation':
            'Eviction requires lease-default records, legal notice, and filing before proper forum.',
        'laws': <String>[
          'Transfer of Property Act, 1882',
          'State Rent Control Act',
          'Code of Civil Procedure, 1908',
        ],
        'steps': <String>[
          'Step 1: Send tenancy termination and eviction notice.',
          'Step 2: Document default and possession refusal.',
          'Step 3: File eviction and damages claim.',
        ],
        'docs': <String>[
          'Lease deed',
          'Rent default proof',
          'Notice delivery receipts',
        ],
        'type': 'Property Lawyer',
        'keywords': <String>['tenant', 'vacate', 'rent', 'lease'],
      },
      <String, dynamic>{
        'id': 'lg04',
        'title': 'Landlord not returning security deposit',
        'explanation':
            'Deposit recovery proceeds through notice, mediation, and civil recovery suit where needed.',
        'laws': <String>[
          'Indian Contract Act, 1872',
          'Transfer of Property Act, 1882',
        ],
        'steps': <String>[
          'Step 1: Issue legal notice for deposit refund.',
          'Step 2: Attempt documented mediation.',
          'Step 3: File civil recovery claim with interest.',
        ],
        'docs': <String>[
          'Rent agreement',
          'Deposit payment record',
          'Exit handover proof',
        ],
        'type': 'Civil Litigation Lawyer',
        'keywords': <String>['deposit', 'landlord', 'rent', 'refund'],
      },
      <String, dynamic>{
        'id': 'lg05',
        'title': 'Online UPI fraud',
        'explanation':
            'UPI fraud needs immediate banking complaint and cybercrime registration.',
        'laws': <String>[
          'Information Technology Act, 2000',
          'Bharatiya Nyaya Sanhita, 2023',
          'RBI Payment Guidelines',
        ],
        'steps': <String>[
          'Step 1: Report fraud to bank and UPI app.',
          'Step 2: File complaint on cybercrime.gov.in.',
          'Step 3: Lodge FIR with cyber police.',
        ],
        'docs': <String>[
          'Transaction screenshots',
          'Bank statement',
          'Cyber complaint acknowledgement',
        ],
        'type': 'Cyber Crime Lawyer',
        'keywords': <String>['upi', 'fraud', 'scam', 'online', 'cyber'],
      },
      <String, dynamic>{
        'id': 'lg06',
        'title': 'Credit card unauthorized transactions',
        'explanation':
            'Card disputes involve issuer liability process and consumer remedy for wrongful denial.',
        'laws': <String>[
          'RBI Card Liability Circular',
          'Consumer Protection Act, 2019',
          'Information Technology Act, 2000',
        ],
        'steps': <String>[
          'Step 1: Block card and register dispute.',
          'Step 2: Escalate to nodal officer and ombudsman.',
          'Step 3: File consumer case for refund and damages.',
        ],
        'docs': <String>[
          'Card statement',
          'Dispute complaint reference',
          'Bank communication history',
        ],
        'type': 'Consumer and Banking Lawyer',
        'keywords': <String>['credit card', 'unauthorized', 'chargeback'],
      },
      <String, dynamic>{
        'id': 'lg07',
        'title': 'Divorce by mutual consent',
        'explanation':
            'Mutual divorce follows two-motion family court procedure with settlement terms.',
        'laws': <String>[
          'Hindu Marriage Act, 1955',
          'Special Marriage Act, 1954',
          'Family Courts Act, 1984',
        ],
        'steps': <String>[
          'Step 1: Finalize settlement on custody and finances.',
          'Step 2: File first motion petition.',
          'Step 3: Appear for second motion and decree.',
        ],
        'docs': <String>[
          'Marriage certificate',
          'Identity proofs',
          'Settlement draft',
        ],
        'type': 'Family Lawyer',
        'keywords': <String>['divorce', 'mutual consent', 'marriage'],
      },
      <String, dynamic>{
        'id': 'lg08',
        'title': 'Child custody dispute',
        'explanation':
            'Custody matters are decided on child welfare, stability, and safety considerations.',
        'laws': <String>[
          'Guardians and Wards Act, 1890',
          'Family Courts Act, 1984',
          'Hindu Minority and Guardianship Act, 1956',
        ],
        'steps': <String>[
          'Step 1: Prepare child-care and schooling evidence.',
          'Step 2: Seek interim custody/visitation orders.',
          'Step 3: Pursue final custody adjudication.',
        ],
        'docs': <String>[
          'Child birth certificate',
          'School/medical records',
          'Parent income and residence proof',
        ],
        'type': 'Family Lawyer',
        'keywords': <String>['custody', 'child', 'visitation'],
      },
      <String, dynamic>{
        'id': 'lg09',
        'title': 'Domestic violence protection',
        'explanation':
            'Urgent protection and residence relief can be sought through DV Act process.',
        'laws': <String>[
          'Protection of Women from Domestic Violence Act, 2005',
          'Bharatiya Nagarik Suraksha Sanhita, 2023',
        ],
        'steps': <String>[
          'Step 1: File domestic incident report.',
          'Step 2: Apply for interim protection orders.',
          'Step 3: Seek maintenance and compensation orders.',
        ],
        'docs': <String>[
          'Incident evidence',
          'Medical papers',
          'Police complaint copy',
        ],
        'type': 'Family and Criminal Lawyer',
        'keywords': <String>['domestic violence', 'abuse', 'protection'],
      },
      <String, dynamic>{
        'id': 'lg10',
        'title': 'Consumer complaint for defective product',
        'explanation':
            'Defective product claims can be pursued through consumer notice and commission filing.',
        'laws': <String>[
          'Consumer Protection Act, 2019',
          'Consumer Protection Rules, 2020',
        ],
        'steps': <String>[
          'Step 1: Send replacement/refund legal notice.',
          'Step 2: Prepare defect evidence and valuation.',
          'Step 3: File complaint before consumer commission.',
        ],
        'docs': <String>[
          'Invoice and warranty',
          'Product defect evidence',
          'Seller communication trail',
        ],
        'type': 'Consumer Lawyer',
        'keywords': <String>['consumer', 'defective', 'refund', 'warranty'],
      },
      <String, dynamic>{
        'id': 'lg11',
        'title': 'Builder delay in possession',
        'explanation':
            'Delayed project possession may be pursued before RERA and consumer forums.',
        'laws': <String>[
          'RERA Act, 2016',
          'Consumer Protection Act, 2019',
        ],
        'steps': <String>[
          'Step 1: Review builder agreement timeline.',
          'Step 2: File RERA complaint for possession/refund.',
          'Step 3: Seek compensation in consumer forum.',
        ],
        'docs': <String>[
          'Builder agreement',
          'Payment receipts',
          'RERA project details',
        ],
        'type': 'Property and RERA Lawyer',
        'keywords': <String>['builder', 'rera', 'possession', 'flat'],
      },
      <String, dynamic>{
        'id': 'lg12',
        'title': 'Cheque bounce case',
        'explanation':
            'Dishonoured cheque matters follow statutory notice and complaint timelines.',
        'laws': <String>[
          'Negotiable Instruments Act, 1881',
          'Bharatiya Nagarik Suraksha Sanhita, 2023',
        ],
        'steps': <String>[
          'Step 1: Issue statutory demand notice.',
          'Step 2: Preserve service proof and non-payment record.',
          'Step 3: File Section 138 complaint.',
        ],
        'docs': <String>[
          'Cheque details',
          'Bank return memo',
          'Notice copy and dispatch proof',
        ],
        'type': 'Criminal and Commercial Lawyer',
        'keywords': <String>['cheque bounce', 'section 138', 'dishonour'],
      },
      <String, dynamic>{
        'id': 'lg13',
        'title': 'Cyberbullying and online harassment',
        'explanation':
            'Online abuse cases need evidence preservation and rapid platform/police escalation.',
        'laws': <String>[
          'Information Technology Act, 2000',
          'Bharatiya Nyaya Sanhita, 2023',
        ],
        'steps': <String>[
          'Step 1: Capture screenshots and links with timestamps.',
          'Step 2: Report offending profile/content on platform.',
          'Step 3: File cyber police complaint for takedown and action.',
        ],
        'docs': <String>[
          'Screenshots and profile URLs',
          'Platform report reference',
          'Identity proof',
        ],
        'type': 'Cyber Crime Lawyer',
        'keywords': <String>['harassment', 'cyberbullying', 'online abuse'],
      },
      <String, dynamic>{
        'id': 'lg14',
        'title': 'Company not paying invoice',
        'explanation':
            'Commercial dues are recoverable through legal notice, MSME route, or civil proceedings.',
        'laws': <String>[
          'Indian Contract Act, 1872',
          'MSME Development Act, 2006',
          'Code of Civil Procedure, 1908',
        ],
        'steps': <String>[
          'Step 1: Send payment demand with reconciliation.',
          'Step 2: File MSME facilitation claim if eligible.',
          'Step 3: Pursue recovery suit or arbitration.',
        ],
        'docs': <String>[
          'Invoices and POs',
          'Delivery proof',
          'Contract and payment terms',
        ],
        'type': 'Commercial Litigation Lawyer',
        'keywords': <String>['invoice', 'payment due', 'company dues'],
      },
      <String, dynamic>{
        'id': 'lg15',
        'title': 'Trademark infringement by competitor',
        'explanation':
            'Brand misuse can be restrained through cease-and-desist and injunction proceedings.',
        'laws': <String>[
          'Trade Marks Act, 1999',
          'Code of Civil Procedure, 1908',
        ],
        'steps': <String>[
          'Step 1: Collect evidence of infringing use.',
          'Step 2: Send cease-and-desist notice.',
          'Step 3: File infringement and passing-off suit.',
        ],
        'docs': <String>[
          'Trademark certificate',
          'Infringing samples/screenshots',
          'Business usage records',
        ],
        'type': 'IP Lawyer',
        'keywords': <String>['trademark', 'brand copy', 'infringement'],
      },
      <String, dynamic>{
        'id': 'lg16',
        'title': 'Police refusal to register FIR',
        'explanation':
            'If FIR is refused, escalate complaint and move magistrate for directions.',
        'laws': <String>[
          'Bharatiya Nagarik Suraksha Sanhita, 2023',
          'Constitution of India Article 21',
        ],
        'steps': <String>[
          'Step 1: Submit written complaint to SHO.',
          'Step 2: Escalate to Superintendent of Police.',
          'Step 3: File magistrate application for FIR direction.',
        ],
        'docs': <String>[
          'Written complaint copy',
          'Evidence set',
          'Escalation acknowledgment',
        ],
        'type': 'Criminal Lawyer',
        'keywords': <String>['fir', 'police refused', 'complaint'],
      },
      <String, dynamic>{
        'id': 'lg17',
        'title': 'Medical negligence claim',
        'explanation':
            'Negligence claims require medical records, expert opinion, and compensation pleadings.',
        'laws': <String>[
          'Consumer Protection Act, 2019',
          'Law of Torts',
          'Medical Council Regulations',
        ],
        'steps': <String>[
          'Step 1: Obtain complete treatment records.',
          'Step 2: Seek independent medical expert opinion.',
          'Step 3: File compensation claim before proper forum.',
        ],
        'docs': <String>[
          'Medical records and bills',
          'Expert opinion',
          'Hospital communications',
        ],
        'type': 'Medical Negligence Lawyer',
        'keywords': <String>['medical negligence', 'hospital', 'malpractice'],
      },
      <String, dynamic>{
        'id': 'lg18',
        'title': 'Will and inheritance dispute',
        'explanation':
            'Succession disputes involve probate validation and partition claims where rights conflict.',
        'laws': <String>[
          'Indian Succession Act, 1925',
          'Hindu Succession Act, 1956',
          'Code of Civil Procedure, 1908',
        ],
        'steps': <String>[
          'Step 1: Verify will execution and witnesses.',
          'Step 2: Seek probate or succession certificate.',
          'Step 3: File partition/declaration suit if contested.',
        ],
        'docs': <String>[
          'Will and death certificate',
          'Legal heir records',
          'Property ownership documents',
        ],
        'type': 'Property and Succession Lawyer',
        'keywords': <String>['inheritance', 'will', 'succession'],
      },
      <String, dynamic>{
        'id': 'lg19',
        'title': 'Road accident compensation claim',
        'explanation':
            'Injury claims are filed before MACT with proof of negligence and financial loss.',
        'laws': <String>[
          'Motor Vehicles Act, 1988',
          'Bharatiya Nyaya Sanhita, 2023',
        ],
        'steps': <String>[
          'Step 1: Register FIR and secure treatment records.',
          'Step 2: Gather insurance and vehicle ownership details.',
          'Step 3: File MACT compensation petition.',
        ],
        'docs': <String>[
          'FIR and site records',
          'Medical reports and bills',
          'Insurance policy documents',
        ],
        'type': 'Motor Accident Claims Lawyer',
        'keywords': <String>['accident', 'mact', 'compensation'],
      },
      <String, dynamic>{
        'id': 'lg20',
        'title': 'Workplace sexual harassment complaint',
        'explanation':
            'POSH complaints can proceed through Internal Committee and legal escalation channels.',
        'laws': <String>[
          'POSH Act, 2013',
          'Bharatiya Nyaya Sanhita, 2023',
          'Industrial Relations Code, 2020',
        ],
        'steps': <String>[
          'Step 1: File written complaint with Internal Committee.',
          'Step 2: Preserve communication and witness details.',
          'Step 3: Seek police and labour remedies where applicable.',
        ],
        'docs': <String>[
          'Written complaint copy',
          'Incident evidence',
          'HR and IC correspondence',
        ],
        'type': 'Labour and POSH Lawyer',
        'keywords': <String>['sexual harassment', 'posh', 'workplace abuse'],
      },
    ];

    return entries
        .map(
          (entry) => LegalGuidance(
            id: entry['id'] as String,
            problemTitle: entry['title'] as String,
            explanation: entry['explanation'] as String,
            applicableLaws: entry['laws'] as List<String>,
            pathwaySteps: entry['steps'] as List<String>,
            requiredDocuments: entry['docs'] as List<String>,
            recommendedLawyerType: entry['type'] as String,
            keywords: entry['keywords'] as List<String>,
          ),
        )
        .toList(growable: false);
  }

  static List<LegalBook> _buildLegalBooks() {
    final books = <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'kb01',
        'title': 'Constitution of India: Preamble and Rights',
        'category': 'Constitution',
        'author': 'Government of India (Public Domain)',
        'year': 1950,
        'description':
            'Constitutional foundations with focus on rights and remedies.',
        'chapters': <String>[
          'Preamble values and constitutional morality.',
          'Fundamental Rights and enforceability.',
          'How writ remedies are used in practice.',
        ],
      },
      <String, dynamic>{
        'id': 'kb02',
        'title': 'Directive Principles and Fundamental Duties',
        'category': 'Constitution',
        'author': 'Public Legal Education Cell',
        'year': 1976,
        'description':
            'Understanding state policy principles and citizen duties.',
        'chapters': <String>[
          'Role of Directive Principles in welfare policy.',
          'Nature and scope of Fundamental Duties.',
          'Balancing rights and duties in constitutional interpretation.',
        ],
      },
      <String, dynamic>{
        'id': 'kb03',
        'title': 'Writ Jurisdiction Under Articles 32 and 226',
        'category': 'Constitution',
        'author': 'Constitutional Law Resource Centre',
        'year': 2021,
        'description': 'Practical guide to constitutional writ petitions.',
        'chapters': <String>[
          'When to choose Article 32 or Article 226.',
          'Habeas corpus, mandamus, certiorari, prohibition, quo warranto.',
          'Maintainability checklist and drafting structure.',
        ],
      },
      <String, dynamic>{
        'id': 'kb04',
        'title': 'Bharatiya Nyaya Sanhita: Core Offences',
        'category': 'Criminal Law',
        'author': 'Legislative Digest Series',
        'year': 2023,
        'description': 'Core criminal provisions and ingredient-based reading.',
        'chapters': <String>[
          'Offences against person and property.',
          'Economic and cyber-linked criminal provisions.',
          'Defence strategy and common procedural pitfalls.',
        ],
      },
      <String, dynamic>{
        'id': 'kb05',
        'title': 'Bharatiya Nagarik Suraksha Sanhita Procedure',
        'category': 'Criminal Law',
        'author': 'Criminal Procedure Collective',
        'year': 2023,
        'description':
            'Case flow from FIR to appeal with stage-wise checkpoints.',
        'chapters': <String>[
          'FIR registration and investigation safeguards.',
          'Arrest, remand, and bail workflow.',
          'Trial sequence and post-judgment remedies.',
        ],
      },
      <String, dynamic>{
        'id': 'kb06',
        'title': 'Evidence Law Essentials',
        'category': 'Criminal Law',
        'author': 'National Law Publishing',
        'year': 2018,
        'description':
            'Admissibility, relevance, electronic records, and witness practice.',
        'chapters': <String>[
          'Relevance and admissibility principles.',
          'Digital evidence and certification requirements.',
          'Examination and cross-examination basics.',
        ],
      },
      <String, dynamic>{
        'id': 'kb07',
        'title': 'Code of Civil Procedure: Filing to Decree',
        'category': 'Civil Law',
        'author': 'Civil Courts Reference Board',
        'year': 1908,
        'description': 'Lifecycle of civil suits including execution stage.',
        'chapters': <String>[
          'Institution, jurisdiction, and pleadings.',
          'Interim relief, evidence, and hearing stages.',
          'Judgment, decree execution, and appeals.',
        ],
      },
      <String, dynamic>{
        'id': 'kb08',
        'title': 'Specific Relief Act in Practice',
        'category': 'Civil Law',
        'author': 'Commercial Law Institute',
        'year': 1963,
        'description':
            'Specific performance, injunctions, and equitable remedies.',
        'chapters': <String>[
          'Specific performance prerequisites.',
          'Temporary and permanent injunction standards.',
          'Defences against equitable relief.',
        ],
      },
      <String, dynamic>{
        'id': 'kb09',
        'title': 'Limitation Act Timeline Handbook',
        'category': 'Civil Law',
        'author': 'Litigation Strategy Forum',
        'year': 1963,
        'description':
            'How limitation periods affect civil recovery and property claims.',
        'chapters': <String>[
          'Computing limitation periods accurately.',
          'Condonation principles and delay applications.',
          'Common limitation errors in practice.',
        ],
      },
      <String, dynamic>{
        'id': 'kb10',
        'title': 'Companies Act 2013 for Founders',
        'category': 'Corporate Law',
        'author': 'MCA Public Resources',
        'year': 2013,
        'description': 'Corporate governance and statutory compliance basics.',
        'chapters': <String>[
          'Incorporation and board governance framework.',
          'Filings, resolutions, and disclosure obligations.',
          'Compliance defaults and penalties.',
        ],
      },
      <String, dynamic>{
        'id': 'kb11',
        'title': 'LLP Act Compliance Manual',
        'category': 'Corporate Law',
        'author': 'Corporate Compliance Desk',
        'year': 2008,
        'description': 'Practical compliance obligations for LLP entities.',
        'chapters': <String>[
          'LLP formation and partner rights.',
          'Annual filing and audit matrix.',
          'Disputes, conversion, and closure.',
        ],
      },
      <String, dynamic>{
        'id': 'kb12',
        'title': 'Insolvency and Bankruptcy Code Primer',
        'category': 'Corporate Law',
        'author': 'IBC Research Forum',
        'year': 2016,
        'description': 'Resolution process and creditor rights under IBC.',
        'chapters': <String>[
          'Initiation thresholds and admission stage.',
          'Committee of creditors and resolution plans.',
          'Liquidation waterfall and litigation touchpoints.',
        ],
      },
      <String, dynamic>{
        'id': 'kb13',
        'title': 'Code on Wages: Employee Rights',
        'category': 'Labour Law',
        'author': 'Labour Law Education Unit',
        'year': 2019,
        'description': 'Wage entitlement, deductions, and recovery channels.',
        'chapters': <String>[
          'Wage definitions and minimum standards.',
          'Recovery process for delayed wages.',
          'Employer compliance duties.',
        ],
      },
      <String, dynamic>{
        'id': 'kb14',
        'title': 'Industrial Relations Code Guide',
        'category': 'Labour Law',
        'author': 'Workplace Policy Forum',
        'year': 2020,
        'description': 'Conciliation, retrenchment, and dispute mechanisms.',
        'chapters': <String>[
          'Industrial dispute and conciliation process.',
          'Layoff and retrenchment safeguards.',
          'Trade union and standing order framework.',
        ],
      },
      <String, dynamic>{
        'id': 'kb15',
        'title': 'Social Security Code Explained',
        'category': 'Labour Law',
        'author': 'Public Employment Law Institute',
        'year': 2020,
        'description': 'PF, gratuity, maternity, and social security coverage.',
        'chapters': <String>[
          'Eligibility and contribution mapping.',
          'Benefit calculations and claims process.',
          'Dispute redress and compliance enforcement.',
        ],
      },
    ];

    return books
        .map(
          (book) => LegalBook(
            id: book['id'] as String,
            title: book['title'] as String,
            category: book['category'] as String,
            author: book['author'] as String,
            year: book['year'] as int,
            description: book['description'] as String,
            chapters: book['chapters'] as List<String>,
          ),
        )
        .toList(growable: false);
  }

  static List<String> _expertiseFor(String specialization) {
    switch (specialization) {
      case 'Criminal Law':
        return <String>['FIR strategy', 'Bail applications', 'Trial defense'];
      case 'Family Law':
        return <String>['Divorce petitions', 'Custody claims', 'Maintenance'];
      case 'Corporate Law':
        return <String>['Contract drafting', 'Compliance notices', 'Advisory'];
      case 'Labour Law':
        return <String>['Wage disputes', 'Termination claims', 'POSH support'];
      case 'Civil Litigation':
        return <String>['Recovery suits', 'Injunctions', 'Appeals'];
      case 'Property Law':
        return <String>['Title due diligence', 'Partition suits', 'Eviction'];
      case 'Consumer Law':
        return <String>[
          'Consumer complaints',
          'Refund disputes',
          'Compensation'
        ];
      case 'Cyber Law':
        return <String>['Cyber complaints', 'Digital evidence', 'Takedown'];
      case 'Tax Law':
        return <String>['GST notices', 'Income tax response', 'Appeals'];
      case 'Startup Compliance':
        return <String>['Incorporation', 'Shareholder docs', 'IP basics'];
      default:
        return <String>['Legal drafting', 'Advisory', 'Representation'];
    }
  }

  static List<String> _cityCourts(String city) {
    switch (city) {
      case 'New Delhi':
        return <String>[
          'Delhi High Court',
          'Saket District Courts',
          'Tis Hazari Courts',
          'NCLT Delhi',
        ];
      case 'Mumbai':
        return <String>[
          'Bombay High Court',
          'City Civil Court Mumbai',
          'Sessions Court Mumbai',
          'DRT Mumbai',
        ];
      case 'Bengaluru':
        return <String>[
          'Karnataka High Court',
          'City Civil Court Bengaluru',
          'Family Court Bengaluru',
          'Commercial Court Bengaluru',
        ];
      case 'Hyderabad':
        return <String>[
          'Telangana High Court',
          'City Civil Court Hyderabad',
          'Labour Court Hyderabad',
          'Family Court Hyderabad',
        ];
      case 'Pune':
        return <String>[
          'District Court Pune',
          'Family Court Pune',
          'Industrial Court Pune',
          'State Consumer Commission',
        ];
      default:
        return <String>['District Court', 'High Court'];
    }
  }

  static List<String> _cityLanguages(String city) {
    switch (city) {
      case 'New Delhi':
        return <String>['English', 'Hindi', 'Punjabi'];
      case 'Mumbai':
        return <String>['English', 'Hindi', 'Marathi'];
      case 'Bengaluru':
        return <String>['English', 'Hindi', 'Kannada'];
      case 'Hyderabad':
        return <String>['English', 'Hindi', 'Telugu'];
      case 'Pune':
        return <String>['English', 'Hindi', 'Marathi'];
      default:
        return <String>['English', 'Hindi'];
    }
  }

  static String _lawyerId(int number) =>
      'l${number.toString().padLeft(2, '0')}';

  static String _reviewerDisplayName(String fullName) {
    final parts = fullName.split(' ');
    if (parts.length < 2) {
      return fullName;
    }
    return '${parts.first} ${parts.last[0]}.';
  }

  static double _averageRating(List<LawyerReview> reviews) {
    if (reviews.isEmpty) {
      return 4.5;
    }
    final average =
        reviews.fold<double>(0, (sum, review) => sum + review.rating) /
            reviews.length;
    return double.parse(average.toStringAsFixed(1));
  }
}

class _UserSeed {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profilePhoto;
  final bool isVerified;
  final DateTime createdAt;

  const _UserSeed({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePhoto,
    required this.isVerified,
    required this.createdAt,
  });
}
