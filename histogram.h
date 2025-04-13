// histogram.h

typedef struct {
  int * bin;
  double min;
  double max;
  int n;
  double nbin;
} histogram;

int add_to_histo(histogram * h, double x) {
  int k;
  if (x >= h->min && x < h->max) {
    k = (int) ((x - h->min) / (h->max - h->min) * h->nbin);
    h->n++;
    h->bin[k]++;
    return 0;
  } else {
    return 1;
  }
}

histogram * new_histogram(int nbin, double min, double max) {
  histogram * h;
  h = calloc (1, sizeof(histogram));
  h->nbin = nbin;
  h->min = min;
  h->max = max;
  h->bin = calloc(nbin, sizeof(int));
  return h;
}

double * histogram_xdata(histogram *h) {
  double * x;
  x = calloc(h->nbin, sizeof(double));
  for (int i = 0; i < h->nbin; i++) {
    x[i] = h->min + (i + 0.5) * (h->max - h->min) / h->nbin;
  }
  return (x);
}

// normalized probability distribution from histogram
double * histogram_distr(histogram *h) {
  double * y;
  y = calloc(h->nbin, sizeof(double));
  for (int i = 0; i < h->nbin; i++) {
    y[i] = ((double) h->bin[i] / h->n) * h->nbin / (h->max - h->min);
  }
  return (y);
}

