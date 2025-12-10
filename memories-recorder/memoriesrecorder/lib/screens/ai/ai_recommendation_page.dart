import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../widgets/ai_activity_card.dart';
import '../../widgets/ai_reply_bubble.dart';

class AIRecommendationPage extends StatelessWidget {
  const AIRecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    // Contoh data dummy rekomendasi AI
    final activityRecommendations = [
      const AIActivityCard(
        title: 'Mindful Morning Walk',
        description:
            'Take a 15–20 minute walk without your phone. Fokus pada napas, langkah, dan suara di sekitar.',
      ),
      const AIActivityCard(
        title: 'Gratitude Journaling',
        description:
            'Tuliskan tiga hal kecil yang kamu syukuri hari ini. Tidak perlu besar, yang penting jujur dan personal.',
      ),
      const AIActivityCard(
        title: 'Digital Detox Session',
        description:
            'Matikan notifikasi selama 1 jam. Gunakan waktu itu hanya untuk aktivitas yang membuatmu tenang.',
      ),
    ];

    const String promptExample =
        'Aku merasa lelah secara mental setelah minggu yang sibuk. '
        'Kegiatan kecil apa yang bisa membantuku pulih di akhir pekan ini?';

    const String aiReplyExample =
        'Berikut beberapa aktivitas sederhana yang bisa kamu coba:\n\n'
        '1. Jalan pelan di area yang tenang selama 20–30 menit tanpa membawa ponsel.\n'
        '2. Luangkan 10 menit untuk menulis jurnal tentang apa yang paling melelahkan dan apa yang ingin kamu syukuri.\n'
        '3. Jadwalkan satu aktivitas santai yang kamu nikmati, misalnya membaca buku atau menonton film favorit.\n'
        '4. Tetapkan batas: misalnya tidak membuka chat atau email pekerjaan selama beberapa jam.\n\n'
        'Kuncinya: pilih aktivitas yang ringan, realistis, dan kamu lakukan dengan penuh kesadaran, bukan sekadar “menghabiskan waktu”.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recommendations'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Bagian konten scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Intro
                    Text(
                      'AI dapat membantumu mengubah isi memori menjadi rekomendasi aktivitas atau refleksi yang lebih terstruktur.',
                      style: textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section: rekomendasi aktivitas
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_outlined,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Suggested Activities',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // List kartu rekomendasi (vertikal)
                    Column(
                      children: [
                        for (final card in activityRecommendations) ...[
                          card,
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Kamu bisa memilih salah satu aktivitas di atas sebagai tindak lanjut dari memori yang kamu tulis.',
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Divider(
                      thickness: 0.8,
                      color: theme.dividerColor.withOpacity(0.6),
                    ),

                    const SizedBox(height: 16),

                    // Section: contoh percakapan
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Example Conversation',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Begini kira-kira contoh kamu bertanya ke AI dan bagaimana AI merespons.',
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const AIReplyBubble(
                      text: promptExample,
                      isUser: true,
                    ),
                    const AIReplyBubble(
                      text: aiReplyExample,
                      isUser: false,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Input area di bawah (dummy, belum kirim AI beneran)
            Container(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                12,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -2),
                    blurRadius: 8,
                    color: Colors.black.withOpacity(0.03),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText:
                            'Tulis pertanyaanmu ke AI (mis. “Aku sedang cemas tentang …”)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Ini masih UI demo. Integrasi AI nyata belum diimplementasikan.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
