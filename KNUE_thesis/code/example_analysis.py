"""Example analysis script for the thesis template.

This file is intentionally small so it can be included in the appendix.
Replace the sample data and analysis with your own research code.
"""

from statistics import mean

pretest_scores = [68.4, 70.2, 66.8, 69.1, 67.5]
posttest_scores = [82.1, 81.4, 83.0, 80.7, 82.6]

def average_gain(pretest, posttest):
    """Return the average gain between two score lists."""
    gains = [post - pre for pre, post in zip(pretest, posttest)]
    return mean(gains)

if __name__ == "__main__":
    print(f"Pretest mean: {mean(pretest_scores):.2f}")
    print(f"Posttest mean: {mean(posttest_scores):.2f}")
    print(f"Average gain: {average_gain(pretest_scores, posttest_scores):.2f}")
