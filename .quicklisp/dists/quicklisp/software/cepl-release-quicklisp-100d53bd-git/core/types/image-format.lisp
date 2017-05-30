(in-package :cepl.image-formats)

;;----------------------------------------------------------------------

(defvar *unsigned-normalized-integer-formats*
  '(:r8 :r16 :rg8 :rg16 :rgb4 :rgb5 :rgb8 :rgb10 :rgb12 :rgb16
    :rgba2 :rgba4 :rgba5 :rgba8 :rgba12 :rgba16))

(defvar *signed-normalized-integer-formats*
  '(:r8-snorm :r16-snorm :rg8-snorm :rg16-snorm :rgb8-snorm :rgb16-snorm
    :rgba8-snorm :rgba16-snorm))

(defvar *signed-integral-formats*
  '(;; Thus GL-RGBA8I gives a signed integer
    ;; format where each of the four components is an integer on the
    ;; range [-128, 127].
    :r8i :r16i :r32i :rg8i :rg16i :rg32i :rgb8i :rgb16i :rgb32i :rgba8i :rgba16i
    :rgba32i))

(defvar *unsigned-integral-formats*
  '(;; Unsigned integral format. The values go from [0, MAX-INT] for the
    ;; integer size.
    :r8ui :r16ui :r32ui :rg8ui :rg16ui :rg32ui :rgb8ui :rgb16ui :rgb32ui
    :rgba8ui :rgba16ui :rgba32ui))

(defvar *floating-point-formats*
  '(;; Floating-point.
    ;; Thus, GL-RGBA32F is a floating-point format where
    ;; each component is a 32-bit IEEE floating-point value.
    :r16f :r32f :rg16f :rg32f :rgb16f :rgb32f :rgba16f :rgba32f))

(defvar *regular-color-formats*
  (append
   *unsigned-normalized-integer-formats*
   *signed-normalized-integer-formats*
   *signed-integral-formats*
   *unsigned-integral-formats*
   *floating-point-formats*))

;;----------------------------------------------------------------------

(defvar *special-color-formats*
  '(;; Normalized integer, with 3 bits for R and G, but only 2 for B.
    :r3-g3-b2

    ;; 5 bits each for RGB, 1 for Alpha. This format is generally trumped
    ;; by compressed formats (see below), which give greater than 16-bit quality
    ;; in much less storage than 16-bits of color.
    :rgb5-a1

    ;; 10 bits each for RGB, 2 for Alpha. This can be a useful format for
    ;; framebuffers, if you don't need a high-precision destination alpha value.
    ;; It carries more color depth, thus preserving subtle gradations.
    ;; They can also be used for normals, though there is no signed-normalized
    ;; version, so you have to do the conversion manually. It is also a
    ;; required format, so you can count on it being present.
    :rgb10-a2

    ;; 10 bits each for RGB, 2 for Alpha, as unsigned integers.
    ;; There is no signed integral version.
    :rgb10-a2ui

    ;; This uses special 11 and 10-bit floating-point values. An 11-bit float
    ;; has no sign-bit; it has 6 bits of mantissa and 5 bits of exponent.
    ;; A 10-bit float has no sign-bit, 5 bits of mantissa and 5 bits of
    ;; exponent.
    ;; This is very economical for floating-point values (using only 32-bits
    ;; per value), so long as your floating-point data will fit within the given
    ;; range. And so long as you can live without the destination alpha.
    :r11f-g11f-b10f

    ;; This one is complicated. It is an RGB format of type floating-point.
    ;; The 3 color values have 9 bits of precision, and they share a single
    ;; exponent.
    ;; The computation for these values is not as simple as for
    ;; GL-R11F-G11F-B10F, and they aren't appropriate for everything.
    ;; But they can provide better results than that format if most of the
    ;; colors in the image have approximately the same exponent, or are too
    ;; small to be significant. This is a required format, but it is not
    ;; required for renderbuffers so do not expect to be able to render to these
    :rgb9-e5))

;;----------------------------------------------------------------------

;; sRGB colorspace (non-linear colorspaces)

;; When fetching from sRGB images in Shaders, either through Samplers or images,
;; the values retrieved are converted from the sRGB colors into linear
;; colorspace.
;; Note that the alpha value, when present, is always considered linear.

;; When images with this format are used as a render target, OpenGL will
;; automatically convert the output colors from linear to the sRGB
;; colorspace if, and only if, :FRAMEBUFFER-SRGB is enabled.
;; The alpha will be written as given.
;; When writing multiple outputs, only outputs written to sRGB image formats
;; will undergo such conversion.

(defvar *srgb-color-formats*
  '(;; sRGB image with no alpha.
    :srgb8

    ;; sRGB image with a linear Alpha.
    :srgb8-alpha8))


;;----------------------------------------------------------------------

(defvar *red/green-compressed-formats*
  '(;; Unsigned normalized 1-component only.
    :compressed-red-rgtc1

    ;; Signed normalized 1-component only.
    :compressed-signed-red-rgtc1

    ;; Unsigned normalized 2-components.
    :compressed-rg-rgtc2

    ;; Signed normalized 2-components.
    :compressed-signed-rg-rgtc2))


;; (OpenGL 4.2 or ARB-texture-compression-bptc only)
;;
(defvar *bptc-compressed-formats*
  '(;; Unsigned normalized 4-components.
    :compressed-rgba-bptc-unorm

    ;; Unsigned normalized 4-components in the sRGB colorspace.
    :compressed-srgb-alpha-bptc-unorm

    ;; Signed, floating-point 3-components.
    :compressed-rgb-bptc-signed-float

    ;; Unsigned, floating-point 3-components.
    :compressed-rgb-bptc-unsigned-float))

(defvar *s3tc/dxt-compessed-formats*
  '(:compressed-rgb-s3tc-dxt1-ext
    :compressed-rgba-s3tc-dxt1-ext
    :compressed-rgba-s3tc-dxt3-ext
    :compressed-rgba-s3tc-dxt5-ext

    ;; Texture compression can be combined with colors in the sRGB colorspace
    ;; via the EXT-texture-sRGB extension this providing
    :compressed-srgb-s3tc-dxt1-ext
    :compressed-srgb-alpha-s3tc-dxt1-ext
    :compressed-srgb-alpha-s3tc-dxt3-ext
    :compressed-srgb-alpha-s3tc-dxt5-ext))

;;----------------------------------------------------------------------

(defvar *depth-formats*
  '(:depth-component16
    :depth-component24
    :depth-component32
    :depth-component32f))

;;----------------------------------------------------------------------

(defvar *stencil-formats* '(:stencil-index8))

;;----------------------------------------------------------------------

(defvar *depth-stencil-formats* '(:depth24-stencil8 :depth32f-stencil8))

;;----------------------------------------------------------------------

(defvar *color-renderable-formats*
  (append *regular-color-formats*
          *srgb-color-formats*
          '(:r3-g3-b2 :rgb5-a1 :rgb10-a2 :rgb10-a2ui)))

;;----------------------------------------------------------------------

(defvar *valid-image-formats-for-buffer-backed-texture*
  '(:r16 :r16f :r16i :r16ui :r32f :r32i :r32ui :r8 :r8i :r8ui :rg16 :rg16f
    :rg16i :rg16ui :rg32f :rg32i :rg32ui :rg8 :rg8i :rg8ui :rgb32f :rgb32i
    :rgb32ui :rgba16 :rgba16f :rgba16i :rgba16ui :rgba32f :rgba32i :rgba8
    :rgba8i :rgba8ui :rgba32ui))

;;----------------------------------------------------------------------

(defvar *image-formats*
  (append *color-renderable-formats*
          *depth-formats*
          *stencil-formats*
          *depth-stencil-formats*))

;;----------------------------------------------------------------------

(defun image-formatp (format)
  (not (null (find format *image-formats*))))

(defun valid-image-format-for-buffer-backed-texturep (format)
  (not (null (find format *valid-image-formats-for-buffer-backed-texture*))))

(defun color-renderable-formatp (format)
  (not (null (find format *color-renderable-formats*))))

(defun depth-formatp (format)
  (not (null (find format *depth-formats*))))

(defun stencil-formatp (format)
  (not (null (find format *stencil-formats*))))

(defun depth-stencil-formatp (format)
  (not (null (find format *depth-stencil-formats*))))
