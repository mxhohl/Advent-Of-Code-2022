from collections import namedtuple


Range = namedtuple('Range', ['min', 'max'])


def main():
    data = read_data("input.txt")
    overlaping_pairs = get_overlaping_pairs(data)
    fully_contained_pairs = get_fully_contained_pairs(overlaping_pairs)

    print(f"Fullly contained pairs count: {len(fully_contained_pairs)}")
    print(f"Overlaping pairs count: {len(overlaping_pairs)}")


def get_fully_contained_pairs(data: list[tuple[Range, Range]]):
    fully_contained = []
    for pair in data:
        if pair[0].min >= pair[1].min and pair[0].max <= pair[1].max or\
           pair[1].min >= pair[0].min and pair[1].max <= pair[0].max:
            fully_contained.append(pair)
    return fully_contained


def get_overlaping_pairs(data: list[tuple[Range, Range]]):
    overlaping = []
    for pair in data:
        if pair[0].min <= pair[1].max and pair[0].max >= pair[1].min or\
           pair[1].min <= pair[0].max and pair[1].max >= pair[0].min:
            overlaping.append(pair)
    return overlaping


def read_data(path: str) -> list[tuple[Range, Range]]:
    data = []
    with open(path) as file:
        for line in file.readlines():
            raw_pairs = [p.split('-') for p in line.split(',')]
            data.append((
                Range(int(raw_pairs[0][0]), int(raw_pairs[0][1])),
                Range(int(raw_pairs[1][0]), int(raw_pairs[1][1]))
            ))
    return data


if __name__ == "__main__":
    main()
