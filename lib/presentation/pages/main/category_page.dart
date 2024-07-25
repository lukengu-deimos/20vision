import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/widgets/container_with_bg.dart';
import 'package:visionapp/core/widgets/loader.dart';
import 'package:visionapp/presentation/blocs/category_bloc.dart';
import 'package:visionapp/presentation/pages/main/single_category_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    context.read<CategoryBloc>().add(FetchCategory());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = (size.width - 50)/2;
    return Scaffold(
      appBar: AppBar(
        title:  const Text(
          'CATEGORIES',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
      ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            ContainerWithBg(child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(
                      child: Loader(
                        color: AppPalette.unselectedBlue,
                      ));
                }
                if (state is CategoryListFetched) {
                  //final categories = state.categories;
                  return SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20,
                                    right: 20),
                                child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    removeBottom: true,
                                    child: GridView.count(
                                  scrollDirection: Axis.vertical,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  children: List.generate(state.categories.length, (index) {
                                    return InkWell(onTap: (){
                                      SystemSound.play(SystemSoundType.click);
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SingleCategoryPage(category: state.categories[index])));
                                    },child:Stack(
                                      children: [
                                        ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                            child:  CachedNetworkImage(
                                              imageUrl: state.categories[index].imageUrl,
                                              fit: BoxFit.cover,
                                              width: width,
                                              height: width,
                                            )
                                        ),
                                        Container(
                                          width: width,
                                          height: width,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.4),
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: width,
                                          height: width,
                                          color: Colors.transparent,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Positioned(
                                                  bottom: 10,
                                                  right: 10,
                                                  child:  Text(
                                                    state.categories[index].name.toUpperCase(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 17),
                                                  ))
                                            ],
                                          ),
                                        ),

                                      ],
                                    ));
                                  }),
                                )),
                              ))
                        ],
                      ));
                }
                return const SizedBox();
              },
            )),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.9),
                padding: const EdgeInsets.all(8.0),
                height: 15,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ),
            )
          ],
        ));
  }
}
