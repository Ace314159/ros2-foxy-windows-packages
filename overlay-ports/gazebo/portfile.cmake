vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Ace314159/gazebo
    REF f350acaf78badbc784e49811f099ee9ba62f97b3
    SHA512 80524ea6808b80a399dbede335f38fc6c95af0fdc0abe3839541cbf8e9c6b2e52d8e10cdc6eb73989bfa7f5fa43a8ddee196d75bf17dac48bdd666ca90a40d23
    HEAD_REF gazebo11
    PATCHES
        0001-Fix-deps.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        openal    HAVE_OPENAL
        ffmpeg    FFMPEG_FEATURE
        gts       GTS_FEATURE
    INVERTED_FEATURES
        simbody   CMAKE_DISABLE_FIND_PACKAGE_Simbody
        dart      CMAKE_DISABLE_FIND_PACKAGE_DART
        bullet    CMAKE_DISABLE_FIND_PACKAGE_BULLET
        libusb    NO_LIBUSB_FEATURE
        gdal      NO_GDAL_FEATURE
        graphviz  NO_GRAPHVIZ_FEATURE
)

vcpkg_add_to_path("${CURRENT_HOST_INSTALLED_DIR}/debug/bin")
vcpkg_add_to_path("${CURRENT_HOST_INSTALLED_DIR}/bin")
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DUSE_EXTERNAL_TINY_PROCESS_LIBRARY=ON
        -DPKG_CONFIG_EXECUTABLE=${CURRENT_HOST_INSTALLED_DIR}/tools/pkgconf/pkgconf.exe
        ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/gazebo")
vcpkg_copy_pdbs()

vcpkg_copy_tools(
    TOOL_NAMES gazebo gz gzclient gzserver
    AUTO_CLEAN
)
set(EXTRA_OGRE_LIBS Codec_EXR Codec_FreeImage Codec_STBI OgreBites OgreMain OgreMeshLodGenerator OgreOverlay OgrePaging OgreProperty OgreRTShaderSystem OgreTerrain OgreVolume Plugin_BSPSceneManager Plugin_DotScene Plugin_OctreeSceneManager Plugin_OctreeZone Plugin_ParticleFX Plugin_PCZSceneManager RenderSystem_Direct3D11 RenderSystem_GL RenderSystem_GL3Plus)
foreach(LIB IN LISTS EXTRA_OGRE_LIBS)
    set(FILE_NAME "${CMAKE_SHARED_LIBRARY_PREFIX}${LIB}${CMAKE_SHARED_LIBRARY_SUFFIX}")
    file(COPY "${CURRENT_INSTALLED_DIR}/bin/${FILE_NAME}" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
endforeach()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
