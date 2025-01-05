//
//  PageViewController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 30/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public final class PageViewController: UIPageViewController {
    
    private(set) var pages: [UIViewController] = []
    private var pageControlIndex = 0
    
    public convenience init(transitionStyle: UIPageViewController.TransitionStyle, pages: [UIViewController] = []) {
        self.init(transitionStyle: transitionStyle, navigationOrientation: .horizontal, options: nil)
        self.pages = pages
    }
    
    public override func viewDidLoad() {
        
        dataSource = self
        updateFirstPage(from: pages)
    }
    
    override public func viewDidLayoutSubviews() {
        
        repositionPageControl()
    }
    
    public func setPages(_ pages: [UIViewController]) {
        self.pages = pages
        updateFirstPage(from: pages)
    }
    
    private func updateFirstPage(from pages: [UIViewController]) {
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true)
        }
    }
    
    private func repositionPageControl() {
        for subView in view.subviews {
            // Change page control 'y' position
            if subView is UIPageControl {
                subView.frame.origin.y = self.view.frame.size.height - 50
                
                if let pageControl = subView as? UIPageControl {
                    pageControl.pageIndicatorTintColor = .gray
                    pageControl.currentPageIndicatorTintColor = .black
                }
            }
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return pages.last }
        
        return pages[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        return pages[nextIndex]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        pageControlIndex
    }
}
