// 전역 주석 저장소
interface CommentData {
  id: number;
  note: string;
  elementId: string;
}

class CommentStore {
  private comments: CommentData[] = [];
  private nextId = 1;
  private listeners: Set<() => void> = new Set();

  addComment(note: string, elementId: string): number {
    const id = this.nextId++;
    this.comments.push({ id, note, elementId });
    this.notifyListeners();
    return id;
  }

  getComments(): CommentData[] {
    return [...this.comments];
  }

  scrollToComment(id: number, scrollToFooter: boolean = false) {
    const comment = this.comments.find((c) => c.id === id);
    if (!comment) {
      return;
    }

    if (scrollToFooter) {
      // 주석 번호 클릭 시: 하단 목록으로만 스크롤
      const footerItem = document.getElementById(`comment-footer-item-${id}`);
      if (footerItem) {
        const rect = footerItem.getBoundingClientRect();
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        const itemTop = rect.top + scrollTop;

        window.scrollTo({
          top: itemTop - 150,
          behavior: 'smooth',
        });

        footerItem.classList.add('comment-highlight');
        setTimeout(() => {
          footerItem.classList.remove('comment-highlight');
        }, 2000);
      }
    } else {
      // 하단 목록 클릭 시: 주석 위치로만 스크롤
      const element = document.getElementById(comment.elementId);
      if (element) {
        const rect = element.getBoundingClientRect();
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        const elementTop = rect.top + scrollTop;

        window.scrollTo({
          top: elementTop - 100,
          behavior: 'smooth',
        });

        element.classList.add('comment-highlight');
        setTimeout(() => {
          element.classList.remove('comment-highlight');
        }, 2000);
      }
    }
  }

  subscribe(listener: () => void) {
    this.listeners.add(listener);
    return () => {
      this.listeners.delete(listener);
    };
  }

  private notifyListeners() {
    this.listeners.forEach((listener) => listener());
  }

  reset() {
    this.comments = [];
    this.nextId = 1;
    this.notifyListeners();
  }
}

export const commentStore = new CommentStore();
