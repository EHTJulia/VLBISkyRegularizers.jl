


# VLBISkyRegularizers

Documentation for [VLBISkyRegularizers](https://github.com/EHTJulia/VLBISkyRegularizers.jl).
- [`VLBISkyRegularizers.ALRDomain`](#VLBISkyRegularizers.ALRDomain)
- [`VLBISkyRegularizers.AbstractRegularizer`](#VLBISkyRegularizers.AbstractRegularizer)
- [`VLBISkyRegularizers.AddRegularizer`](#VLBISkyRegularizers.AddRegularizer)
- [`VLBISkyRegularizers.CLRDomain`](#VLBISkyRegularizers.CLRDomain)
- [`VLBISkyRegularizers.L1`](#VLBISkyRegularizers.L1)
- [`VLBISkyRegularizers.LinearDomain`](#VLBISkyRegularizers.LinearDomain)
- [`VLBISkyRegularizers.LogDomain`](#VLBISkyRegularizers.LogDomain)
- [`VLBISkyRegularizers.ParameterDomain`](#VLBISkyRegularizers.ParameterDomain)
- [`VLBISkyRegularizers.TSV`](#VLBISkyRegularizers.TSV)
- [`VLBISkyRegularizers.TV`](#VLBISkyRegularizers.TV)
- [`VLBISkyRegularizers.WaveletL1`](#VLBISkyRegularizers.WaveletL1)
- [`VLBISkyRegularizers.WeightRegularizer`](#VLBISkyRegularizers.WeightRegularizer)
- [`Distributions._logpdf`](#Distributions._logpdf-Tuple{AbstractRegularizer,%20AbstractMatrix{<:Real}})
- [`VLBISkyRegularizers._transform_linear`](#VLBISkyRegularizers._transform_linear-Tuple{AbstractDomain,%20AbstractArray})
- [`VLBISkyRegularizers.evaluate`](#VLBISkyRegularizers.evaluate-Tuple{TV,%20AbstractArray})
- [`VLBISkyRegularizers.evaluate`](#VLBISkyRegularizers.evaluate-Tuple{AbstractRegularizer,%20AbstractArray})
- [`VLBISkyRegularizers.evaluate`](#VLBISkyRegularizers.evaluate-Tuple{TSV,%20AbstractArray})
- [`VLBISkyRegularizers.evaluate`](#VLBISkyRegularizers.evaluate-Tuple{L1,%20AbstractArray})
- [`VLBISkyRegularizers.evaluation_domain`](#VLBISkyRegularizers.evaluation_domain-Tuple{AbstractRegularizer})
- [`VLBISkyRegularizers.grid`](#VLBISkyRegularizers.grid-Tuple{AbstractRegularizer})
- [`VLBISkyRegularizers.image_domain`](#VLBISkyRegularizers.image_domain-Tuple{AbstractRegularizer})
- [`VLBISkyRegularizers.l1_base`](#VLBISkyRegularizers.l1_base-Tuple{AbstractArray,%20Number})
- [`VLBISkyRegularizers.l1_base`](#VLBISkyRegularizers.l1_base-Tuple{AbstractArray})
- [`VLBISkyRegularizers.regularizers`](#VLBISkyRegularizers.regularizers-Tuple{AbstractRegularizer})
- [`VLBISkyRegularizers.transform_domain`](#VLBISkyRegularizers.transform_domain-Tuple{AbstractDomain,%20AbstractDomain,%20AbstractArray})
- [`VLBISkyRegularizers.transform_image`](#VLBISkyRegularizers.transform_image-Tuple{AbstractDomain,%20AbstractArray})
- [`VLBISkyRegularizers.tsv_base`](#VLBISkyRegularizers.tsv_base-Tuple{AbstractArray,%20Number})
- [`VLBISkyRegularizers.tsv_base`](#VLBISkyRegularizers.tsv_base-Tuple{Any})
- [`VLBISkyRegularizers.tv_base`](#VLBISkyRegularizers.tv_base-Tuple{AbstractArray})
- [`VLBISkyRegularizers.tv_base`](#VLBISkyRegularizers.tv_base-Tuple{AbstractArray,%20Number})
- [`VLBISkyRegularizers.wavelet_transform`](#VLBISkyRegularizers.wavelet_transform-Tuple{AbstractArray,%20WVType})

<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.ALRDomain' href='#VLBISkyRegularizers.ALRDomain'>#</a>&nbsp;<b><u>VLBISkyRegularizers.ALRDomain</u></b> &mdash; <i>Type</i>.




```julia
ALRDomain
```


Additive Log-Ratio transform. Can only be used as an image domain. Image transformation is the inverse ALR function. Similar to softmax but treats one pixel (the last pixel) as special.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/domains.jl#L42-L47)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.AbstractRegularizer' href='#VLBISkyRegularizers.AbstractRegularizer'>#</a>&nbsp;<b><u>VLBISkyRegularizers.AbstractRegularizer</u></b> &mdash; <i>Type</i>.




```julia
AbstractRegularizer
```


Used to define the regularizer functions. See `subtypes(AbstractRegularizer)` for a list of implemented regularizers.

**Mandatory fields**
- `hyperparameter::Number`: the hyperparameter of the regularization function.
  
- `image_domain::AbstractDomain`: the domain of the image space 
  
- `evaluation_domain::AbstractDomain`: the domain on which the regularizer is to be evaluated
  
- `grid`: grid on which image is defined
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/abstract.jl#L3-L14)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.AddRegularizer' href='#VLBISkyRegularizers.AddRegularizer'>#</a>&nbsp;<b><u>VLBISkyRegularizers.AddRegularizer</u></b> &mdash; <i>Type</i>.




```julia
AddRegularizer <: AbstractRegularizer
```


Structure for adding two regularizers. The two regularizers must have the same grid and image domain.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/composite.jl#L3-L7)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.CLRDomain' href='#VLBISkyRegularizers.CLRDomain'>#</a>&nbsp;<b><u>VLBISkyRegularizers.CLRDomain</u></b> &mdash; <i>Type</i>.




```julia
CLRDomain
```


Centered Log-Ratio transformation. Can only be used as an image domain.  Image transformation is the softmax function (applies the exponential function and normalizes by the sum).


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/domains.jl#L34-L39)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.L1' href='#VLBISkyRegularizers.L1'>#</a>&nbsp;<b><u>VLBISkyRegularizers.L1</u></b> &mdash; <i>Type</i>.




```julia
L1 <: AbstractRegularizer
```


Regularizer using the L1 norm.

**fields**
- `hyperparameter::Number`: the hyperparameter of the regularization function.
  
- `image_domain::AbstractDomain`: the domain of the image space 
  
- `evaluation_domain::AbstractDomain`: the domain on which the regularizer is to be evaluated
  
- `grid`: grid on which image is defined
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/l1norm.jl#L3-L13)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.LinearDomain' href='#VLBISkyRegularizers.LinearDomain'>#</a>&nbsp;<b><u>VLBISkyRegularizers.LinearDomain</u></b> &mdash; <i>Type</i>.




```julia
LinearDomain
```


Can be used as an image and evaluation domain. No transformation in evaluation. Image transformation normalizes the image by the sum and absolute value.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/domains.jl#L10-L15)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.LogDomain' href='#VLBISkyRegularizers.LogDomain'>#</a>&nbsp;<b><u>VLBISkyRegularizers.LogDomain</u></b> &mdash; <i>Type</i>.




```julia
LogDomain
```


Can be used as an image and evaluation domain. Logarithmic transformation in evaluation. Image transformation is the softmax function (applies the exponential function and normalizes by the sum).


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/domains.jl#L18-L24)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.ParameterDomain' href='#VLBISkyRegularizers.ParameterDomain'>#</a>&nbsp;<b><u>VLBISkyRegularizers.ParameterDomain</u></b> &mdash; <i>Type</i>.




```julia
ParameterDomain
```


Can only be used as an evaluation domain. Sets the evaluation domain equal to the image domain.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/domains.jl#L27-L31)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.TSV' href='#VLBISkyRegularizers.TSV'>#</a>&nbsp;<b><u>VLBISkyRegularizers.TSV</u></b> &mdash; <i>Type</i>.




```julia
TSV <: AbstractRegularizer
```


Regularizer using the Isotropic Total Squared Variation.

**fields**
- `hyperparameter::Number`: the hyperparameter of the regularization function.
  
- `image_domain::AbstractDomain`: the domain of the image space 
  
- `evaluation_domain::AbstractDomain`: the domain on which the regularizer is to be evaluated
  
- `grid`: grid on which image is defined
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/tsv.jl#L3-L13)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.TV' href='#VLBISkyRegularizers.TV'>#</a>&nbsp;<b><u>VLBISkyRegularizers.TV</u></b> &mdash; <i>Type</i>.




```julia
TV <: AbstractRegularizer
```


Regularizer using the Isotropic Total Variation.

**fields**
- `hyperparameter::Number`: the hyperparameter of the regularization function.
  
- `image_domain::AbstractDomain`: the domain of the image space 
  
- `evaluation_domain::AbstractDomain`: the domain on which the regularizer is to be evaluated
  
- `grid`: grid on which image is defined
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/tv.jl#L3-L13)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.WaveletL1' href='#VLBISkyRegularizers.WaveletL1'>#</a>&nbsp;<b><u>VLBISkyRegularizers.WaveletL1</u></b> &mdash; <i>Type</i>.




```julia
WaveletL1 <: AbstractRegularizer
```


Regularizer using the l1-norm with a wavelet transform

**fields**
- `hyperparameter::Number`: the hyperparameter of the regularization function.
  
- `image_domain::AbstractDomain`: the domain of the image space 
  
- `evaluation_domain::AbstractDomain`: the domain on which the regularizer is to be evaluated
  
- `wavelet::WVType`: wavelet type
  
- `grid`: grid on which image is defined
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/waveletl1norm.jl#L35-L46)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.WeightRegularizer' href='#VLBISkyRegularizers.WeightRegularizer'>#</a>&nbsp;<b><u>VLBISkyRegularizers.WeightRegularizer</u></b> &mdash; <i>Type</i>.




```julia
WeightRegularizer <: AbstractRegularizer
```


Structure for weighting a regularizer by a scalar.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/composite.jl#L23-L27)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='Distributions._logpdf-Tuple{AbstractRegularizer, AbstractMatrix{<:Real}}' href='#Distributions._logpdf-Tuple{AbstractRegularizer, AbstractMatrix{<:Real}}'>#</a>&nbsp;<b><u>Distributions._logpdf</u></b> &mdash; <i>Method</i>.




```julia
Distributions._logpdf(d::Regularizers, image::AbstractMatrix{<:Real})
```


The log density of the regularizers evaluated at the input image. .

**Arguments**
- `reg::Regularizers`: the regularizer functions.
  
- `image::AbstractMatrix{<:Real}`: the model of the input image
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/abstract.jl#L67-L74)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers._transform_linear-Tuple{AbstractDomain, AbstractArray}' href='#VLBISkyRegularizers._transform_linear-Tuple{AbstractDomain, AbstractArray}'>#</a>&nbsp;<b><u>VLBISkyRegularizers._transform_linear</u></b> &mdash; <i>Method</i>.




```julia
_transform_linear(::AbstractDomain, x::AbstractArray)
```


Transforms an array to the linear domain. Same as transform_image but does not necessarily impose non-negativity and normalization.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/domains.jl#L63-L68)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.evaluate-Tuple{AbstractRegularizer, AbstractArray}' href='#VLBISkyRegularizers.evaluate-Tuple{AbstractRegularizer, AbstractArray}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.evaluate</u></b> &mdash; <i>Method</i>.




```julia
evaluate(::AbstractRegularizer, ::AbstractArray)
```


Compute the value of the given regularization function on the input image. By default, return 0.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/abstract.jl#L50-L55)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.evaluate-Tuple{L1, AbstractArray}' href='#VLBISkyRegularizers.evaluate-Tuple{L1, AbstractArray}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.evaluate</u></b> &mdash; <i>Method</i>.




```julia
evaluate(reg::L1, x::AbstractArray)
```


Evaluate the L1 norm regularizer at an image.

**Arguments**
- `reg::L1`: L1 norm regularizer
  
- `x::AbstractArray`: the image
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/l1norm.jl#L48-L56)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.evaluate-Tuple{TSV, AbstractArray}' href='#VLBISkyRegularizers.evaluate-Tuple{TSV, AbstractArray}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.evaluate</u></b> &mdash; <i>Method</i>.




```julia
evaluate(reg::TSV, x::AbstractArray)
```


Evaluate the TSV regularizer at an image.

**Arguments**
- `reg::TSV`: TSV regularizer
  
- `x::AbstractArray`: the image
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/tsv.jl#L47-L55)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.evaluate-Tuple{TV, AbstractArray}' href='#VLBISkyRegularizers.evaluate-Tuple{TV, AbstractArray}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.evaluate</u></b> &mdash; <i>Method</i>.




```julia
evaluate(reg::TV, x::AbstractArray)
```


Evaluate the TV regularizer at an image.

**Arguments**
- `reg::TV`: TV regularizer
  
- `x::AbstractArray`: the image
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/tv.jl#L47-L55)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.evaluation_domain-Tuple{AbstractRegularizer}' href='#VLBISkyRegularizers.evaluation_domain-Tuple{AbstractRegularizer}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.evaluation_domain</u></b> &mdash; <i>Method</i>.




```julia
evaluation_domain(reg::AbstractRegularizer)
```


Return the evaluation domain of the given regularizer.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/abstract.jl#L29-L33)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.grid-Tuple{AbstractRegularizer}' href='#VLBISkyRegularizers.grid-Tuple{AbstractRegularizer}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.grid</u></b> &mdash; <i>Method</i>.




```julia
grid(reg::AbstractRegularizer)
```


Return the grid on which an image to be regularized is defined.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/abstract.jl#L36-L40)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.image_domain-Tuple{AbstractRegularizer}' href='#VLBISkyRegularizers.image_domain-Tuple{AbstractRegularizer}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.image_domain</u></b> &mdash; <i>Method</i>.




```julia
image_domain(reg::AbstractRegularizer)
```


Return the image domain of the given regularizer.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/abstract.jl#L22-L26)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.l1_base-Tuple{AbstractArray, Number}' href='#VLBISkyRegularizers.l1_base-Tuple{AbstractArray, Number}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.l1_base</u></b> &mdash; <i>Method</i>.




```julia
l1_base(x::AbstractArray, w::Number)
```


Base function of the L1 norm.

**Arguments**
- `x::AbstractArray`: the image
  
- &#39;w::Number&#39; : the regularization weight
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/l1norm.jl#L35-L43)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.l1_base-Tuple{AbstractArray}' href='#VLBISkyRegularizers.l1_base-Tuple{AbstractArray}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.l1_base</u></b> &mdash; <i>Method</i>.




```julia
l1_base(x::AbstractArray)
```


Base function of the L1 norm.

**Arguments**
- `x::AbstractArray`: the image
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/l1norm.jl#L24-L31)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.regularizers-Tuple{AbstractRegularizer}' href='#VLBISkyRegularizers.regularizers-Tuple{AbstractRegularizer}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.regularizers</u></b> &mdash; <i>Method</i>.




```julia
regularizers(::AbstractRegularizer)
```


List regularizers used.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/abstract.jl#L43-L47)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.transform_domain-Tuple{AbstractDomain, AbstractDomain, AbstractArray}' href='#VLBISkyRegularizers.transform_domain-Tuple{AbstractDomain, AbstractDomain, AbstractArray}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.transform_domain</u></b> &mdash; <i>Method</i>.




```julia
transform_domain(::LinearDomain, x::AbstractArray)
```


Transform the domain of the image to the evaluation domain.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/domains.jl#L76-L80)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.transform_image-Tuple{AbstractDomain, AbstractArray}' href='#VLBISkyRegularizers.transform_image-Tuple{AbstractDomain, AbstractArray}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.transform_image</u></b> &mdash; <i>Method</i>.




```julia
transform_image(::AbstractDomain, x::AbstractArray)
```


Transforms an array to the normalized, non-negative image domain.


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/domains.jl#L51-L55)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.tsv_base-Tuple{AbstractArray, Number}' href='#VLBISkyRegularizers.tsv_base-Tuple{AbstractArray, Number}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.tsv_base</u></b> &mdash; <i>Method</i>.




```julia
tsv_base(x::AbstractArray, w::Number)
```


Base function of the isotropic total squared variation.

**Arguments**
- `x::AbstractArray`: the image
  
- &#39;w::Number&#39; : the regularization weight
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/tsv.jl#L35-L43)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.tsv_base-Tuple{Any}' href='#VLBISkyRegularizers.tsv_base-Tuple{Any}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.tsv_base</u></b> &mdash; <i>Method</i>.




```julia
tsv_base(x::AbstractArray)
```


Base function of the isotropic total squared variation.

**Arguments**
- `x::AbstractArray`: the image
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/tsv.jl#L24-L31)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.tv_base-Tuple{AbstractArray, Number}' href='#VLBISkyRegularizers.tv_base-Tuple{AbstractArray, Number}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.tv_base</u></b> &mdash; <i>Method</i>.




```julia
tv_base(x::AbstractArray, w::Number)
```


Base function of the isotropic total variation.

**Arguments**
- `x::AbstractArray`: the image
  
- &#39;w::Number&#39; : the regularization weight
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/tv.jl#L35-L43)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.tv_base-Tuple{AbstractArray}' href='#VLBISkyRegularizers.tv_base-Tuple{AbstractArray}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.tv_base</u></b> &mdash; <i>Method</i>.




```julia
tv_base(x::AbstractArray)
```


Base function of the isotropic total variation.

**Arguments**
- `x::AbstractArray`: the image
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/tv.jl#L24-L31)

</div>
<br>
<div style='border-width:1px; border-style:solid; border-color:black; padding: 1em; border-radius: 25px;'>
<a id='VLBISkyRegularizers.wavelet_transform-Tuple{AbstractArray, WVType}' href='#VLBISkyRegularizers.wavelet_transform-Tuple{AbstractArray, WVType}'>#</a>&nbsp;<b><u>VLBISkyRegularizers.wavelet_transform</u></b> &mdash; <i>Method</i>.




```julia
wavelet_l1_base(x::AbstractArray, wv::WaveletL1)
```


Base function of the Wavelet L1 norm.

**Arguments**
- `x::AbstractArray`: the image
  
- `wv::WVType` : the wavelet transform type
  


[source](https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/b546fc08bf85e577dfdda752c25b5d5453591d37/src/regularizers/waveletl1norm.jl#L58-L66)

</div>
<br>
