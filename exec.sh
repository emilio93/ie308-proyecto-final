mkdir -p plots

mkdir -p pdfs
mkdir -p img
for archivo in ./spices/*.cir; do
  archivo="${archivo/.cir/}"
  echo  "ngspice -b ${archivo}.cir"
  ngspice -b ${archivo}.cir
done

mkdir -p pdfs
for plot in ./plots/*.plt; do
  echo "********************************"
  name=${plot/.plt/}
  single=${name/.\/plots\//}
  echo "${name}"
  echo "${single}"
  echo "********************************"

  sed -i 's/set\ terminal\ X11/set\ terminal\ pdf/g'              "${name}.plt"
  sed -i "s/set terminal postscript eps color/set terminal pdf/g" "${name}.plt"
  sed -i "s/set title .*/set title \"\"/g"                        "${name}.plt"
  sed -i "s/set out 'plots/set out 'pdfs/g"                       "${name}.plt"
  
  sed -i 's/#set y2tics 1/set key top rmargin/g'  "${name}.plt"

  sed -i "s/v(2)/Vin/g"    "${name}.plt"
  sed -i "s/v(4)/Vout/g"   "${name}.plt"
  sed -i "s/v(5,rn)/Vrl/g" "${name}.plt"
  sed -i "s/v(rp,rn)/Vc/g" "${name}.plt"
  sed -i "s/v(rn,vout)/Vo/g" "${name}.plt"

  sed -i 's/set ylabel "V"/set ylabel "Tensión [V]"/g' "${name}.plt"
  sed -i 's/set xlabel "s"/set xlabel "Tiempo [s]"/g'  "${name}.plt"
  sed -i 's/#set x2tics 1/set ylabel "Tensión [V]"/g'  "${name}.plt"

  # sed -i 's/set xrange \[1\.000320e-01\:1\.666667e-01\]/set xrange [1e-01:1.666667e-01]/g' "${name}.plt"
  #
  # sed -i 's/#set ytics 1/set ytics 2/g'           "${name}.plt"
  # sed -i 's/#set xtics 1/set xtics 16.66667e-3/g' "${name}.plt"
  # sed -i 's/#set y2tics 1/set key top rmargin/g'  "${name}.plt"

  gnuplot "${name}.plt" > /dev/null
  inkscape "pdfs/${single}.eps" --export-pdf "pdfs/${single}.pdf"
  inkscape "pdfs/${single}.eps" --export-plain-svg "img/${single}.svg" --export-width=1024

  gnuplot "${name}.plt" > /dev/null
  inkscape "pdfs/${single}.eps" --export-pdf "pdfs/${single}.pdf"
  inkscape "pdfs/${single}.eps" --export-plain-svg "img/${single}.svg" --export-width=1024
done
