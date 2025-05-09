import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsDetailsScreen extends StatelessWidget {
  final String title;
  final List<String> imageNames;
  final String date;

  const NewsDetailsScreen({
    super.key,
    required this.title,
    required this.imageNames,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color _primaryColor = const Color(0xFFD4A373);
    final Color _darkBackground = const Color(0xFF1A120B);

    String content;
    if (title.contains('جهود الحكومة')) {
      content =
          'اجتمع السيد الرئيس/ عبد الفتاح السيسي، اليوم، مع كل من الدكتور مصطفى مدبولي رئيس مجلس الوزراء، والفريق مهندس كامل الوزير نائب رئيس الوزراء للتنمية الصناعية ووزير النقل والصناعة، والسيد أحمد كجوك وزير المالية، والمهندس حسن الخطيب وزير الاستثمار والتجارة الخارجية.\n'
          'وصرح المُتحدث الرسمي باسم رئاسة الجمهورية بأن الاجتماع استعرض جهود الحكومة لتهيئة مناخ الأعمال وجذب المزيد من الاستثمارات المحلية والأجنبية، حيث تم في هذا الإطار عرض موقف الأعباء الإجرائية التي يتحملها المستثمرون، والخطة المقترحة لتخفيف هذه الأعباء مثل توحيد جهة التحصيل وتدشين منصة الكيانات الاقتصادية.\n'
          'وأشار السفير محمد الشناوي المتحدث الرسمي إلى أن السيد الرئيس وجه باستبدال الرسوم التي تتقاضاها الجهات والهيئات المختلفة بضريبة إضافية موحدة من صافي الربح، مؤكداً سيادته على ضرورة خلق مناخ استثماري أكثر تنافسية يشهد المستثمر من خلاله تحسناً ملموساً وسريعاً على أرض الواقع في سهولة أداء الأعمال في مصر، من خلال تبسيط الإجراءات، وتخفيف الأعباء المالية.\n'
          'وذكر المتحدث الرسمي أن الاجتماع تناول كذلك جهود تقليل زمن الإفراج الجمركي بحيث يكون المستهدف هو تخفيض عدد الأيام اللازمة للإفراج الجمركي من ثمانية إلى ستة أيام، مع استمرار عمل الخدمات الجمركية بالعطلات الرسمية وأيام الجمعة، وإتاحة إمكانية سداد الرسوم بعد انتهاء ساعات العمل بالبنوك. وتناول الاجتماع أيضاً محاور البرنامج الجديد لرد أعباء الصادرات، والذي يستهدف دعم الصناعة الوطنية وزيادة الصادرات المصرية لمختلف الأسواق العالمية، حيث أكد سيادته على أهمية أن تتضمن محاور البرنامج الجديد تحقيق مستهدفات الدولة الخاصة بزيادة الصادرات حتى عام ٢٠٣٠.\n'
          'وأضاف المتحدث الرسمي أنه تم خلال الاجتماع استعراض جهود صندوق مصر السيادي لتعظيم العائد من الأصول المملوكة للدولة، وأبرز الجهود التي تتم في إطار تنفيذ برنامج الطروحات الحكومية، في ضوء مخرجات وثيقة سياسة ملكية الدولة، وذلك سعياً لتعظيم العائد على الأصول المملوكة للدولة من خلال بناء شراكات واسعة مع القطاع الخاص.\n'
          'وأوضح المتحدث الرسمي أن السيد الرئيس قد شدد على ضرورة منح القطاع الخاص الدور المحوري الرئيسي في دفع عجلة الاقتصاد، وزيادة الصادرات، وذلك من خلال تـشجيع الاسـتثمارات الوطنية في مجال الإنتاج والتصدير، وتوفير الخدمات اللازمة للمصدرين.';
    } else if (title.contains('وزير المالية')) {
      content =
          'وزير المالية.. للعاملين بالجمارك:\n\n'
          'دوركم «مؤثر جدًا» في تحفيز الاستثمار والإنتاج والتصدير\n\n'
          'معًا.. سنطور المنظومة الجمركية بتبسيط الإجراءات للتيسير على مجتمع الأعمال\n\n'
          'سنعمل بكل جهد سويًا.. لخفض زمن وتكلفة الإفراج الجمركى وتحسين وتبسيط الاجراءات\n\n'
          'سنعمل بتنسيق وتعاون كامل مع زملائنا فى وزارة الاستثمار والتجارة الخارجية لتعزيز تنافسية الاقتصاد المصرى\n\n'
          'سأتواجد بينكم في المنافذ لدفع مسار «التسهيلات الجمركية» لتوطين الصناعة وجذب المزيد من الاستثمارات المحلية والخارجية\n\n'
          'رئيس المصلحة الجديد: لدينا فرصة كبيرة لتحديث المنظومة الجمركية.. برؤية أكثر شمولاً وتكاملاً مع «جهات العرض»\n\n'
          'سنكون دائمًا في «حالة حوار» لتجاوز التحديات الجمركية.. بمعالجات مرنة تحقق مصلحة الجميع\n\n'
          'تعزيز الاستثمار في العنصر البشري.. لضمان رفع كفاءة المنظومة الجمركية.';
    } else {
      content = 'No content available.';
    }

    return Scaffold(
      body: Container(
        decoration: _buildBackgroundGradient(isDarkMode),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 40.h,
                  bottom: 80.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppBar(context, isDarkMode),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 250.h,
                      child: PageView.builder(
                        itemCount: imageNames.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.asset(
                              'assets/images/${imageNames[index]}',
                              height: 250.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode
                                ? const Color(0xFFF5F5DC)
                                : _darkBackground,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: (isDarkMode
                                ? const Color(0xFFF5F5DC)
                                : _darkBackground)
                            .withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1.5,
                        color:
                            isDarkMode
                                ? const Color(0xFFF5F5DC)
                                : _darkBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(isDarkMode, context),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 24.w,
              color: isDarkMode ? Colors.white : const Color(0xFF1A120B),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'News Details',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color:
                  isDarkMode
                      ? const Color(0xFFF5F5DC)
                      : const Color(0xFF1A120B),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildBackgroundGradient(bool isDarkMode) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors:
            isDarkMode
                ? [
                  const Color(0xFF1A120B),
                  const Color(0xFF3C2A21),
                  const Color(0xFFD4A373).withOpacity(0.2),
                ]
                : [
                  Colors.white,
                  const Color(0xFFF5F5DC).withOpacity(0.6),
                  const Color(0xFFD4A373).withOpacity(0.1),
                ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDarkMode, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A120B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0, isDarkMode, context),
              _buildNavItem(Icons.article, 'News', 1, isDarkMode, context),
              _buildNavItem(Icons.person, 'Profile', 2, isDarkMode, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    bool isDarkMode,
    BuildContext context,
  ) {
    final isSelected = false; // No selection on details screen
    return GestureDetector(
      onTap: () => _handleNavigation(index, context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28.w,
            color:
                isSelected
                    ? const Color(0xFFD4A373)
                    : (isDarkMode
                        ? const Color(0xFFF5F5DC).withOpacity(0.6)
                        : const Color(0xFF1A120B).withOpacity(0.6)),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color:
                  isSelected
                      ? const Color(0xFFD4A373)
                      : (isDarkMode
                          ? const Color(0xFFF5F5DC).withOpacity(0.6)
                          : const Color(0xFF1A120B).withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index, BuildContext context) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/media');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }
}
